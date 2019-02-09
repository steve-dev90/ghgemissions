class Power::UserEmissions
  include Power::TradingPeriodTimeConverter

  def initialize(user_energy)
    @user_energy = user_energy
  end

  def calculate_user_emissions_factors_by_trader
    HalfHourlyEmission
      .joins('INNER JOIN profiles ON profiles.trading_period = half_hourly_emissions.trading_period')
      .joins('INNER JOIN traders ON traders.code = half_hourly_emissions.trader')
      .select('traders.name as trader, sum(profiles.profile *
        half_hourly_emissions.emissions_factor) as emissions_factor')
      .group('traders.name')
  end

  def calculate_user_emissions
    user_emissions_factors_by_trading_period.reduce([]) do |result, record|
      result << {
        trading_period: convert_trading_period_to_24hrtime(record[:trading_period]),
        user_emission: record[:emissions_factor] * @user_energy
      }
    end
  end

  private

  def user_emissions_factors_by_trading_period
    HalfHourlyEmission
      .joins('INNER JOIN profiles ON profiles.trading_period = half_hourly_emissions.trading_period')
      .select('half_hourly_emissions.trading_period,
        sum(profiles.profile * half_hourly_emissions.emissions_factor) as emissions_factor')
      .group('trading_period')
      .order(trading_period: :asc)
  end
end

class Power::UserEmissions
  include Power::TradingPeriodTimeConverter

  def initialize(user_energy, month)
    @user_energy = user_energy
    @month = month
  end

  def calculate_user_emissions_factors_by_trader
    HalfHourlyEmission
      .joins('INNER JOIN profiles ON profiles.period = half_hourly_emissions.period AND
        profiles.month = half_hourly_emissions.month')
      .joins('INNER JOIN traders ON traders.code = half_hourly_emissions.trader')
      .select('traders.name as trader, sum(profiles.profile *
        half_hourly_emissions.emissions_factor) as emissions_factor')
      .where("profiles.energy_type = ? AND half_hourly_emissions.month = ?",
        EnergyType.find_by(name: 'power').id, @month)
      .group('traders.name')
  end

  def calculate_user_emissions
    user_emissions_factors_by_trading_period
      .map { |r| { period: r[:period].to_i, user_emissions_factor: r[:user_emissions_factor] } }
      .sort_by { |r| r[:period] }
      .map do |r|
        { trading_period: convert_trading_period_to_24hrtime(r[:period]),
          user_emission: r[:user_emissions_factor] * @user_energy }
    end
  end

  private

  def user_emissions_factors_by_trading_period
    HalfHourlyEmission
      .joins('INNER JOIN profiles ON profiles.period = half_hourly_emissions.period AND
        profiles.month = half_hourly_emissions.month')
      .select('half_hourly_emissions.period,
        sum(profiles.profile * half_hourly_emissions.emissions_factor) as user_emissions_factor')
      .where("profiles.energy_type = ? AND half_hourly_emissions.month = ?",
        EnergyType.find_by(name: 'power').id, @month)
      .group('half_hourly_emissions.period, half_hourly_emissions.month')
  end
end

class Power::UserEmissions
  include Power::TradingPeriodTimeConverter

  def calculate_user_emissions_factors_by_trader
    HalfHourlyEmission
      .joins('INNER JOIN profiles ON profiles.period = half_hourly_emissions.period')
      .joins('INNER JOIN traders ON traders.code = half_hourly_emissions.trader')
      .select('traders.name as trader, sum(profiles.profile *
        half_hourly_emissions.emissions_factor) as emissions_factor')
      .group('traders.name')
  end

  def calculate_user_emissions_factors
    user_emissions_factors_by_trading_period
      .map { |r| { period: r[:period].to_i, user_emissions_factor: r[:user_emissions_factor] } }
      .sort_by { |r| r[:period] }
      .map do |r|
        { trading_period: convert_trading_period_to_24hrtime(r[:period]),
          user_emissions_factor: r[:user_emissions_factor] }
    end
  end

  private

  def user_emissions_factors_by_trading_period
    HalfHourlyEmission
      .joins('INNER JOIN profiles ON profiles.period = half_hourly_emissions.period')
      .select('half_hourly_emissions.period,
        sum(profiles.profile * half_hourly_emissions.emissions_factor) as user_emissions_factor')
      .group('period')
  end
end

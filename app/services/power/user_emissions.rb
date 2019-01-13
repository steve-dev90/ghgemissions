class Power::UserEmissions
  def initialize(user_energy)
    @user_energy = user_energy
  end

  def calculate_user_emissions_by_trader
    system_emissions_by_trader.reduce([]) do |result, record|
      user_emission = @user_energy *
                      Profile.find_by(trading_period: record[:trading_period])[:profile] *
                      record[:emissions_factor]
      result << {
        date: record[:date],
        trading_period: record[:trading_period],
        trader: record[:trader],
        user_emission: user_emission
      }
    end
  end

  def calculate_user_emissions
    system_emissions.reduce([]) do |result, record|
      pp record
      user_emission = @user_energy *
                      Profile.find_by(trading_period: record[:trading_period])[:profile] *
                      record[:emissions_factor]
      result << {
        trading_period: record[:trading_period],
        user_emission: user_emission
      }
    end
  end

  private

  def system_emissions_by_trader
    HalfHourlyEmission
      .select(:date, :trading_period, :trader, :emissions_factor)
      .order(trader: :asc)
      .order(trading_period: :asc)
  end

  def system_emissions
    HalfHourlyEmission
      .select("trading_period, sum(emissions_factor) as emissions_factor")
      .group("trading_period")
      .order(trading_period: :asc)
  end
end

class Power::UserEmissions
  def initialize(user_energy)
    @user_energy = user_energy
  end

  def call
    calculate_user_emissions(system_emissions)
  end

  def system_emissions
    HalfHourlyEmission.select(:date, :trading_period, :trader, :emissions_factor)
  end

  def calculate_user_emissions(systems_emissions)
    systems_emissions.reduce([]) do |result, record|
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
end

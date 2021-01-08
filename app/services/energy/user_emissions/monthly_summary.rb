require 'forwardable'

class Energy::UserEmissions::MonthlySummary
  def initialize(dashboard_params)
    @dashboard_params = dashboard_params
  end

  def call
    @power = Energy::UserEmissions::MonthlyPower.new(@dashboard_params)
    gas = Energy::UserEmissions::MonthlyGas.new(@dashboard_params)
    car = Energy::UserEmissions::MonthlyCar.new(@dashboard_params)
    [{ emissions_source: 'Power', user_emission: @power.user_emissions },
     { emissions_source: 'Gas', user_emission: gas.user_emissions },
     { emissions_source: 'Car', user_emission: car.user_emissions }]
  end

  def previous_month_power
    # power = Energy::UserEmissions::MonthlyPower.new(@dashboard_params)
    @power.previous_month_energy(
      @dashboard_params[:power_user_energy],
      @dashboard_params[:power_start_date],
      @dashboard_params[:power_end_date],
      'power'
    )
  end
end

class Energy::UserEmissions::MonthlyEnergy
  def initialize(dashboard_params)
    @dashboard_params = dashboard_params
  end

  def previous_month
    Date.parse(Time.new.to_s).prev_month.month
  end

  def previous_month_energy(billed_energy, start_date, end_date, energy_type)
    Energy::PreviousMonthEnergyEstimate.new(
      billed_energy.to_f, start_date, end_date, previous_month, energy_type
    ).call
  end

  def emission_factor(fuel_type, unit)
    EmissionFactor
      .where('fuel_type = ? AND units = ?', fuel_type, unit)
      .first[:factor]
  end
end

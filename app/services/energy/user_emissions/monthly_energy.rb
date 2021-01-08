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
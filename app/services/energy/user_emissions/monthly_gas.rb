class Energy::UserEmissions::MonthlyGas < Energy::UserEmissions::MonthlyEnergy
  def initialize(dashboard_params)
    super(dashboard_params)
    @energy_type = 'gas'
  end

  def user_emissions
    return 0.0 if @dashboard_params[:gas_user_energy].empty?

    emission_factor('natural_gas', 'kgCO2/kWh') *
      previous_month_energy(
        @dashboard_params[:gas_user_energy],
        @dashboard_params[:gas_start_date],
        @dashboard_params[:gas_end_date],
        @energy_type
      )
  end
end

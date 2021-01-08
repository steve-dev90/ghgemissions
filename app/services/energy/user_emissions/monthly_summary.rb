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
    @power.previous_month_energy(
      @dashboard_params[:power_user_energy],
      @dashboard_params[:power_start_date],
      @dashboard_params[:power_end_date],
      'power'
    )
  end
end
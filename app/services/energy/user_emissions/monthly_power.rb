class Energy::UserEmissions::MonthlyPower < Energy::UserEmissions::MonthlyEnergy
  def initialize(dashboard_params)
    super(dashboard_params)
    @energy_type = 'power'
  end

  def user_emissions
    Power::UserEmissions.new(
      previous_month_energy(
        @dashboard_params[:power_user_energy],
        @dashboard_params[:power_start_date],
        @dashboard_params[:power_end_date],
        @energy_type
      ),
      previous_month
    )
                        .calculate_user_emissions
                        .sum { |e| e[:user_emission] }
  end
end

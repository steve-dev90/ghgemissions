require 'forwardable'

class Energy::UserEmissions
  attr_reader :dashboard_params

  def initialize(dashboard_params)
    @dashboard_params = dashboard_params
  end

  def call
    power = Energy::PowerEmissions.new(@dashboard_params, Energy::EnergyEmissions.new())
    gas= Energy::GasEmissions.new(@dashboard_params, Energy::EnergyEmissions.new())
    car_emissions = {}
    [ { emissions_source: 'Power', user_emission: power.user_emissions },
      { emissions_source: 'Gas', user_emission: gas.user_emissions },
      car_emissions ]
  end
end

class Energy::EnergyEmissions
  def initialize()
  end

  def previous_month
    Date.parse(Time.new.to_s).prev_month.month
  end

  def previous_month_energy(billed_energy, start_date, end_date, previous_month, energy_type)
    Energy::PreviousMonthEnergyEstimate.new(
      billed_energy.to_f, start_date, end_date, previous_month, energy_type).call
  end
end

class Energy::EnergyEmissionDecorator
  extend Forwardable
    def_delegators :@energy_emissions, :previous_month, :previous_month_energy

  def initialize(energy_emissions)
    @energy_emissions = energy_emissions
  end
end

class Energy::PowerEmissions < Energy::EnergyEmissionDecorator
  def initialize(dashboard_params, energy_emissions)
    super(energy_emissions)
    @energy_type = 'power'
    @dashboard_params = dashboard_params
  end

  def user_emissions
    Power::UserEmissions.new(
      @energy_emissions.previous_month_energy(
        @dashboard_params[:power_user_energy],
        @dashboard_params[:power_start_date],
        @dashboard_params[:power_end_date],
        @energy_emissions.previous_month,
        @energy_type
      ),
      @energy_emissions.previous_month)
    .calculate_user_emissions
    .sum{ |e| e[:user_emission] }
  end
end

class Energy::GasEmissions < Energy::EnergyEmissionDecorator
  def initialize(dashboard_params, energy_emissions)
    super(energy_emissions)
    @energy_type = 'gas'
    @dashboard_params = dashboard_params
  end

  def user_emissions
    return 0.0 if @dashboard_params[:gas_user_energy].empty?

    EmissionFactor
      .where("fuel_type = ? AND units = ?", 'natural_gas', "kgCO2/kWh")
      .first[:factor] *
      @energy_emissions.previous_month_energy(
        @dashboard_params[:gas_user_energy].to_f,
        @dashboard_params[:gas_start_date],
        @dashboard_params[:gas_end_date],
        @energy_emissions.previous_month,
        @energy_type
      )
  end
end

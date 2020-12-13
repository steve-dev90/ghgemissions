class Energy::RawProfileData
  def initialize(dashboard_params)
    @dashboard_params = dashboard_params
  end

  def call
    pp "hello"
    # [ power_emissions, gas_emissions, car_emissions]
  end
end
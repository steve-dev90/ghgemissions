class Energy::UserEmissions::MonthlyCar < Energy::UserEmissions::MonthlyEnergy
  FUEL_TYPES = %w[diesel reg_petrol prem_petrol].freeze

  def initialize(dashboard_params)
    super(dashboard_params)
  end

  def car_fuel_price(car_fuel_type)
    AutomotiveFuelPrice
      .where('fuel_type = ?', car_fuel_type)
      .order('month_beginning DESC')
      .first[:fuel_price]
  end

  def user_emission_by_car_fuel_type(car_fuel_type, user_energy, unit, period)
    user_emission = emission_factor(car_fuel_type, 'kgCO2/litre') * user_energy
    user_emission = user_emission * 100.0 / car_fuel_price(car_fuel_type) if unit == '$'
    user_emission *= 4 if period.include? 'week'
    user_emission
  end

  def user_emissions
    FUEL_TYPES.sum do |car_fuel_type|
      user_emission_by_car_fuel_type(
        car_fuel_type,
        @dashboard_params["#{car_fuel_type}_user_energy".to_sym].to_f,
        @dashboard_params["#{car_fuel_type}_unit".to_sym],
        @dashboard_params["#{car_fuel_type}_period".to_sym]
      )
    end
  end
end

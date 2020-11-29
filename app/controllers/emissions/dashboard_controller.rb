module Emissions
  class DashboardController < ApplicationController
    def index
      previous_month = Date.parse(Time.new.to_s).prev_month.month

      @previous_month_power = Energy::PreviousMonthEnergyEstimate.new(
        dashboard_params[:power_user_energy].to_f,
        dashboard_params[:power_start_date],
        dashboard_params[:power_end_date],
        previous_month,
        'power'
      ).call

      power_emissions = {
        emissions_source: 'Power',
        user_emission:
          Power::UserEmissions.new(@previous_month_power, previous_month)
            .calculate_user_emissions
            .sum{ |e| e[:user_emission] }
      }

      if !dashboard_params[:gas_user_energy].empty?
        previous_month_gas = Energy::PreviousMonthEnergyEstimate.new(
          dashboard_params[:gas_user_energy].to_f,
          dashboard_params[:gas_start_date],
          dashboard_params[:gas_end_date],
          previous_month,
          'gas'
        )
        gas_emissions = { emissions_source: 'Gas', user_emission: 53.96 * 0.0036 * previous_month_gas.call}
      else
        gas_emissions = { emissions_source: 'Gas', user_emission: 0}
      end

      # Get the latest petrol price
      pp dashboard_params
      car_emissions = { emissions_source: 'Car', user_emission:
        ['reg_petrol', 'prem_petrol', 'diesel'].sum do |car_fuel_type|
          user_emission= EmissionFactor
            .where("fuel_type = ? AND units = ?", car_fuel_type, "kgCO2/litre")
            .first[:factor] *
            dashboard_params["#{car_fuel_type}_user_energy".to_sym].to_f
          if dashboard_params["#{car_fuel_type}_unit".to_sym] == "Litres"
            car_fuel_price = AutomotiveFuelPrice
            .where("fuel_type = ?", car_fuel_type)
            .order("month_beginning DESC")
            .first[:fuel_price]
            user_emission = user_emission / car_fuel_price
          end
          user_emission = user_emission * 4 if dashboard_params["#{car_fuel_type}_period".to_sym].include? "week"
          user_emission
        end }

      @user_emissions = [ power_emissions, gas_emissions, car_emissions]
      @total_emissions = @user_emissions.sum { |data_pt| data_pt[:user_emission] }.round(1)
    end

    private

    def dashboard_params
      params.permit(:power_user_energy, :power_start_date, :power_end_date,
        :gas_user_energy, :gas_start_date, :gas_end_date, :reg_petrol_period,
        :reg_petrol_user_energy, :reg_petrol_unit, :prem_petrol_period,
        :prem_petrol_user_energy, :prem_petrol_unit, :diesel_period,
        :diesel_user_energy, :diesel_unit)
    end
  end
end

module Emissions
  class DashboardController < ApplicationController
    def index
      monthly_summary = Energy::UserEmissions::MonthlySummary.new(dashboard_params)
      @user_emissions = monthly_summary.call
      @total_emissions = @user_emissions.sum { |data_pt| data_pt[:user_emission] }.round(1)
      @previous_month_power = monthly_summary.previous_month_power
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

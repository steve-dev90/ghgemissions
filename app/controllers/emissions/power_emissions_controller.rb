module Emissions
  class PowerEmissionsController < ApplicationController
    def index
      previous_month = Date.parse(Time.new.to_s).prev_month.month
      @previous_month_power = power_emissions_params[:previous_month_power].to_f
      emissions = Power::UserEmissions.new(@previous_month_power, previous_month)
      @user_emissions = emissions.calculate_user_emissions
      @trader_emissions = emissions.calculate_user_emissions_factors_by_trader
     end

    private

    def power_emissions_params
      params.permit(:previous_month_power)
    end
  end
end

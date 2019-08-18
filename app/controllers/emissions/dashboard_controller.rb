module Emissions
  class DashboardController < ApplicationController
    def index
      previous_month = Date.parse(Time.new.to_s).prev_month.month
      previous_month_power = Power::PreviousMonthEnergyEstimate.new(
        dashboard_params[:user_energy].to_f,
        dashboard_params[:start_date_submit],
        dashboard_params[:end_date_submit],
        previous_month
      )

      @previous_month_power = previous_month_power.call
      emissions = Power::UserEmissions.new(@previous_month_power, previous_month)
      @user_emissions = emissions.calculate_user_emissions
      @total_emissions = @user_emissions.sum{ |e| e[:user_emission]}.round(1)
    end

    private

    def dashboard_params
      params.permit(:user_energy, :start_date_submit, :end_date_submit)
    end
  end
end

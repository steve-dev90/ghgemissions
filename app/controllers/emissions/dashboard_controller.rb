module Emissions
  class DashboardController < ApplicationController
    def index

      pp "hello"
      pp dashboard_params
      previous_month = Date.parse(Time.new.to_s).prev_month.month
      previous_month_power = Power::PreviousMonthEnergyEstimate.new(
        dashboard_params[:user_energy].to_f,
        dashboard_params[:start_date],
        dashboard_params[:end_date],
        previous_month
      )

      @previous_month_power = previous_month_power.call
      emissions = Power::UserEmissions.new(@previous_month_power, previous_month)
      @user_emissions = emissions.calculate_user_emissions
      @total_emissions = @user_emissions.sum{ |e| e[:user_emission]}.round(1)
    end

    private

    def dashboard_params
      params.permit(:user_energy, :start_date, :end_date)
    end
  end
end

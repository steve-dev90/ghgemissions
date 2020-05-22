module Emissions
  class DashboardController < ApplicationController
    def index

      pp "hello"
      pp dashboard_params
      previous_month = Date.parse(Time.new.to_s).prev_month.month

      previous_month_power = Energy::PreviousMonthEnergyEstimate.new(
        dashboard_params[:power_user_energy].to_f,
        dashboard_params[:power_start_date],
        dashboard_params[:power_end_date],
        previous_month,
        'power'
      )
      @previous_month_power = previous_month_power.call

      if !dashboard_params[:gas_user_energy].empty?
        previous_month_gas = Energy::PreviousMonthEnergyEstimate.new(
          dashboard_params[:gas_user_energy].to_f,
          dashboard_params[:gas_start_date],
          dashboard_params[:gas_end_date],
          previous_month,
          'gas'
        )
        previous_month_gas = previous_month_gas.call
        pp previous_month_gas
        gas_emissions = { emissions_source: 'Gas', user_emission: 53.96 * 0.0036 * previous_month_gas}
      else
        gas_emissions = { emissions_source: 'Gas', user_emission: 0}
      end

      emissions = Power::UserEmissions.new(@previous_month_power, previous_month)
      # @user_emissions = emissions.calculate_user_emissions
      @total_emissions = emissions
                            .calculate_user_emissions
                            .sum{ |e| e[:user_emission]}
                            .round(1)

      @user_emissions = [
        { emissions_source: 'Power', user_emission: @total_emissions },
        gas_emissions
      ]

    end

    private

    def dashboard_params
      params.permit(:power_user_energy, :power_start_date, :power_end_date,
        :gas_user_energy, :gas_start_date, :gas_end_date)
    end
  end
end

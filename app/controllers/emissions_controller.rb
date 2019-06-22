class EmissionsController < ApplicationController
  def index
    previous_month = Date.parse(Time.new.to_s).prev_month.month
    energy = Power::PreviousMonthEnergyEstimate.new(
      emissions_params[:user_energy].to_f,
      emissions_params[:start_date_submit],
      emissions_params[:end_date_submit],
      previous_month
    )
    emissions = Power::UserEmissions.new(energy.call, previous_month)
    @user_emissions = emissions.calculate_user_emissions
    @trader_emissions = emissions.calculate_user_emissions_factors_by_trader
    @total_emissions = @user_emissions.sum{ |e| e[:user_emission]}.round(1)
  end

  private

  def emissions_params
    params.permit(:user_energy, :start_date_submit, :end_date_submit)
  end
end

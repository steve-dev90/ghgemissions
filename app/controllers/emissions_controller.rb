class EmissionsController < ApplicationController
  def index
    energy = Power::PreviousMonthEnergyEstimate.new(
      100,
      emissions_params[:start_date_submit],
      emissions_params[:end_date_submit]
    )
    emissions = Power::UserEmissions.new(emissions_params[:user_energy].to_f, 3)
    pp @user_emissions = emissions.calculate_user_emissions
    @trader_emissions = emissions.calculate_user_emissions_factors_by_trader
    @total_emissions = @user_emissions.sum{ |e| e[:user_emission]}.round(1)
  end

  private

  def emissions_params
    params.permit(:user_energy, :start_date_submit, :end_date_submit)
  end
end

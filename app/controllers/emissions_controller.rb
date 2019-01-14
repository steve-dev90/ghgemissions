class EmissionsController < ApplicationController
  def index
    @user_energy = emissions_params[:user_energy]
    emissions = Power::UserEmissions.new(emissions_params[:user_energy].to_f)
    @user_emissions = emissions.calculate_user_emissions
    @trader_emissions = emissions.calculate_user_emissions_factor_by_trader
    # @total_emissions = user_emissions.call.sum{ |e| e[:user_emission]}
  end

  private

  def emissions_params
    params.permit(:user_energy)
  end
end

class EmissionsController < ApplicationController
  def index
    emissions = Power::UserEmissions.new(emissions_params[:user_energy].to_f, 3)
    pp @user_emissions = emissions.calculate_user_emissions
    @trader_emissions = emissions.calculate_user_emissions_factors_by_trader
    @total_emissions = @user_emissions.sum{ |e| e[:user_emission]}.round(1)
  end

  private

  def emissions_params
    params.permit(:user_energy)
  end
end

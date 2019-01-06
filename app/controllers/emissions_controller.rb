class EmissionsController < ApplicationController
  def index
    @message = 'hello'
    @user_energy = emissions_params[:user_energy]
    user_emissions = Power::UserEmissions.new(emissions_params[:user_energy].to_f)
    pp user_emissions.call
    @emissions = user_emissions.call
  end

  private

  def emissions_params
    params.permit(:user_energy)
  end
end

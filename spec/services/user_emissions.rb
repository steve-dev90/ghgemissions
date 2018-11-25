require 'rails_helper'

RSpec.describe UserEmissions do
  before(:all) do
    user_energy = 100
    @user_emissions = UserEmissions.build(user_energy)
    @profile = FactoryBot.create(:profile)
#     [
#   [:factory_1, traits_1_factory_1],
#   [:factory_2, traits_1_factory2]
# ].each do |factory|
#   FactoryBot.create(*factory)
# end
  end

  it 'is obtains the profile data' do
    actual = 
    expect(@cleared_offer1).to be_valid
  end
end

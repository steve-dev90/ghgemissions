require 'rails_helper'

RSpec.describe Power::UserEmissions do
  before(:all) do
    @user_energy = 100.0
    @user_emissions = Power::UserEmissions.new(@user_energy)
    (1..48).each do |trading_period|
      FactoryBot.create(:profile, trading_period: trading_period)
      FactoryBot.create(:half_hourly_emission, trading_period: trading_period)
    end 
  end

  context "one trader, same profile and emissions per trading period" do
    it 'calculates user emissions' do 
      expected = @user_energy * Profile.last[:profile] * HalfHourlyEmission.last[:emissions_factor]
      actuals = @user_emissions.call
      actuals.each do |actual| 
        expect(actual).to eq(expected)
      end
    end
  end  
end

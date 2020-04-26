require 'rails_helper'

RSpec.describe Power::UserEmissions do
  before(:all) do
    @user_energy = 100.0
    @month = 1
    @user_emissions = Power::UserEmissions.new(@user_energy, @month)
    FactoryBot.create(:energy_type)
    FactoryBot.create(:energy_type, name: 'gas', id: 2)
    HalfHourlyEmission.destroy_all
    Profile.destroy_all
    Trader.destroy_all
    trader = Power::TraderData.new
    trader.call
    FactoryBot.create(:profile, period: 'month', energy_type: 2)
    (1..48).each do |trading_period|
      FactoryBot.create(:profile, period: trading_period)
      FactoryBot.create(:profile, period: trading_period, month: 2)
      FactoryBot.create(:half_hourly_emission, period: trading_period)
      FactoryBot.create(:half_hourly_emission, period: trading_period, month: 2)
    end
  end

  context 'one trader, same profile and emissions factor per trading period' do
    it 'calculates user emissions by trading period' do
      # expected = user_energy * profile(=0.1) * emissions_factor(=0.001)
      expected = @user_energy * 0.1 * 0.001
      actuals = @user_emissions.calculate_user_emissions
      actuals.each do |actual|
        expect(actual[:user_emission]).to eq(expected)
      end
    end

    it 'converts trading periods to 24hr time' do
      actuals = @user_emissions.calculate_user_emissions
      expect(actuals[0][:trading_period]).to eq('00:00')
      expect(actuals[3][:trading_period]).to eq('01:30')
      expect(actuals[47][:trading_period]).to eq('23:30')
    end

    it 'calculates user emissions factors by trader' do
      actuals = @user_emissions.calculate_user_emissions_factors_by_trader
      expected = (0.1 * 0.001 * 48).round(4)
      expect(actuals.to_a.size).to eq(1)
      expect(actuals.first[:emissions_factor]).to eq(expected)
    end
  end
end
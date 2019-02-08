require 'rails_helper'

RSpec.describe Power::UserEmissions do
  before(:all) do
    @user_energy = 100.0
    @user_emissions = Power::UserEmissions.new(@user_energy)
    HalfHourlyEmission.destroy_all
    Profile.destroy_all
    Trader.destroy_all
    trader = Power::TraderData.new
    trader.call
    (1..48).each do |trading_period|
      FactoryBot.create(:profile, trading_period: trading_period)
      FactoryBot.create(:half_hourly_emission, trading_period: trading_period)
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

  context 'two traders, emissions factor varies with trading period for second trader' do
    before(:all) do
      (1..48).each do |trading_period|
        FactoryBot.create(:half_hourly_emission,
                          trading_period: trading_period,
                          trader: 'GENE',
                          emissions_factor: 0.005)
      end
    end

    it 'calculates user emissions by trading period' do
      expected = @user_energy * (0.1 * 0.001 + 0.1 * 0.005)
      actuals = @user_emissions.calculate_user_emissions
      actuals.each do |actual|
        expect(actual[:user_emission]).to be_within(0.0001).of(expected)
      end
    end

    it 'calculates user emissions factors by trader' do
      actuals = @user_emissions.calculate_user_emissions_factors_by_trader
      expected_ctct = 0.1 * 0.001 * 48
      actual_ctct = actuals.select{ |a| a[:trader] == 'Contact Energy'}.first[:emissions_factor]
      expected_gene = 0.1 * 0.005 * 48
      actual_gene = actuals.select{ |a| a[:trader] == 'Genesis Energy'}.first[:emissions_factor]
      expect(actuals.to_a.size).to eq(2)
      expect(actual_ctct).to be_within(0.0001).of(expected_ctct)
      expect(actual_gene).to be_within(0.0001).of(expected_gene)
    end
  end
end

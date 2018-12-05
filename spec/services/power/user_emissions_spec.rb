require 'rails_helper'

RSpec.describe Power::UserEmissions do
  EMISSIONS_FACTORS = [
    0.003, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005,
    0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005,
    0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005,
    0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005
  ].freeze

  before(:all) do
    @user_energy = 100.0
    @user_emissions = Power::UserEmissions.new(@user_energy)
    HalfHourlyEmission.destroy_all
    Profile.destroy_all
    (1..48).each do |trading_period|
      FactoryBot.create(:profile, trading_period: trading_period)
      FactoryBot.create(:half_hourly_emission, trading_period: trading_period)
    end
  end

  context 'one trader, same profile and emissions factor per trading period' do
    it 'calculates user emissions' do
      expected = @user_energy * 0.1 * 0.001
      actuals = @user_emissions.call
      actuals.each do |actual|
        expect(actual[:user_emission]).to eq(expected)
      end
    end
  end

  context 'two traders, emissions factor varies with trading period for second trader' do
    it 'calculates user emissions for both traders' do
      (1..48).each do |trading_period|
        FactoryBot.create(:half_hourly_emission,
                          trading_period: trading_period,
                          trader: 'GENE',
                          emissions_factor: EMISSIONS_FACTORS[trading_period - 1])
      end
      actuals = @user_emissions.call
      actual_ctct = user_emissions_first_trading_period(actuals, 'CTCT')
      expect(actual_ctct).to eq(@user_energy * 0.1 * 0.001)
      actual_gene = user_emissions_first_trading_period(actuals, 'GENE')
      expect(actual_gene).to eq(@user_energy * 0.1 * 0.003)
      actual_ctct = user_emissions_total(actuals, 'CTCT')
      expect(actual_ctct).to eq(@user_energy * 0.1 * 0.001 * 48)
      actual_gene = user_emissions_total(actuals, 'GENE')
      expect(actual_gene).to eq(@user_energy * (0.1 * 0.003 + 0.1 * 0.005 * 47))
    end

    def user_emissions_first_trading_period(actuals, trader)
      actuals
        .select { |r| r[:trader] == trader && r[:trading_period] == 1 }
        .first[:user_emission]
    end

    def user_emissions_total(actuals, trader)
      actuals
        .select { |r| r[:trader] == trader }
        .sum { |r| r[:user_emission] }
    end
  end
end

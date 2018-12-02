require 'rails_helper'

RSpec.describe Power::UserEmissions do
  EMISSIONS_FACTORS = [
    0.003, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 
    0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005,
    0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005].freeze  

  before(:all) do
    @user_energy = 100.0
    @user_emissions = Power::UserEmissions.new(@user_energy)
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
      actual_CTCT = user_emissions_first_trading_period(@user_emissions.call, 'CTCT')
      expect(actual_CTCT).to eq(@user_energy * 0.1 * 0.001) 
      actual_GENE = user_emissions_first_trading_period(@user_emissions.call, 'GENE')
      expect(actual_GENE).to eq(@user_energy * 0.1 * 0.003) 
      actual_CTCT = user_emissions_total(@user_emissions.call, 'CTCT')
      expect(actual_CTCT).to eq(@user_energy * 0.1 * 0.001 * 48)                        
      # actual_CTCT_totals =  actuals
      #                       .select{ |r| r.trader == 'CTCT' }
      #                       .sum { |r| r.user_emissions}
      # expect(actual_CTCT_totals).to eq(@user_emissions * 0.1 * 0.001 * 48)                       
      # actual_GENE_tp1 = actuals
      #                   .select{ |r| r.trader == 'GENE' && r.trading_period == 1 }
      #                   .first[:user_emissions] 
      # expect(actual_GENE_tp1).to eq(@user_emissions * 0.2 * 0.003)                                   
      # actual_GENE_totals =  actuals
      #                   .select{ |r| r.trader == 'GENE' }
      #                   .sum { |r| r.user_emissions}
      # expect(actual_CTCT_totals).to eq([PROFILES, EMISSIONS_FACTORS].transpose.map {|a| a.inject(:*)} * @user_energy) 
    end

    def user_emissions_first_trading_period(actuals, trader)
      actuals
        .select{ |r| r[:trader] == trader && r[:trading_period] == 1 }
        .first[:user_emission]
    end 
    
    def user_emissions_total(actuals, trader)
      actuals
        .select{ |r| r[:trader] == trader }
        .sum { |r| r[:user_emission]}        
    end  
  end  
end

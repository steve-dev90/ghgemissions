require 'rails_helper'

RSpec.describe Power::EmissionsData do
  TEST_TRADERS = %w[CTCT GENE TODD MRPL AAAA BBBB CCCC].freeze

  before(:all) do
    ClearedOffer.destroy_all
    (1..3).each do |trading_period|
      TEST_TRADERS.each do |trader|
        (1..2).each do |poc|
          FactoryBot.create(:cleared_offer,
                            trading_period: trading_period,
                            trader: trader,
                            poc: "#{trader.slice(0, 3)}000#{poc} ABC0",
                            cleared_energy: 10,
                            emissions: 2)
        end
      end
    end
    @emissions_data = Power::EmissionsData.new
    @emissions_data.call
  end

  it 'aggregates cleared energy and emissions correctly' do
    %w[CTCT GENE TODD MRPL].each do |trader|
      expect(HalfHourlyEmission.find_by(trader: trader, trading_period: 1)[:energy]).to eq(20)
      expect(HalfHourlyEmission.find_by(trader: trader, trading_period: 1)[:emissions]).to eq(4)
    end
    expect(HalfHourlyEmission.find_by(trader: 'OTHR', trading_period: 1)[:energy]).to eq(60)
    expect(HalfHourlyEmission.find_by(trader: 'OTHR', trading_period: 1)[:emissions]).to eq(12)
  end

  it 'calculates emissions factor correctly' do
    expected_big4 = (4.0 / 140.0).round(6)
    expected_other = (12.0 / 140.0).round(6)
    %w[CTCT GENE TODD MRPL].each do |trader|
      expect(HalfHourlyEmission.find_by(trader: trader, trading_period: 1)[:emissions_factor]).to eq(expected_big4)
    end
    expect(HalfHourlyEmission.find_by(trader: 'OTHR', trading_period: 1)[:emissions_factor]).to eq(expected_other)
  end
end

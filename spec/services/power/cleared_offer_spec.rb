require 'rails_helper'

RSpec.describe Power::ClearedOfferData do
  before(:all) do
    GenerationStation.destroy_all
    FactoryBot.create(:generation_station)
    FactoryBot.create(:generation_station, poc: 'WRK2201 WRK0', emissions_factor: 0.1)
    FactoryBot.create(:generation_station, poc: 'NAP2201 NAP0', emissions_factor: 0.1)
    ClearedOffer.destroy_all
    @cleared_offer = Power::ClearedOfferData.new('./spec/services/power/Cleared_Offers_Test.csv')
    @cleared_offer.call
  end

  it 'uploads the correct number of records' do
    expect(ClearedOffer.count).to eq(5)
  end

  it 'converts cleared energy from MW to MWh' do
    expect(ClearedOffer.find_by(poc: 'GLN0332 GLN0')[:cleared_energy]).to eq(25.0)
    expect(ClearedOffer.find_by(poc: 'CYD2201 CYD0')[:cleared_energy]).to eq(100.0)
  end

  it 'calculates emissions correctly' do
    expect(ClearedOffer.find_by(poc: 'HLY2201 HLY1')[:emissions]).to eq(50.0 *
      GenerationStation.find_by(poc: 'HLY2201 HLY1')[:emissions_factor])
    expect(ClearedOffer.find_by(poc: 'WRK2201 WRK0')[:emissions]).to eq(60.0 * 0.1)
  end
end

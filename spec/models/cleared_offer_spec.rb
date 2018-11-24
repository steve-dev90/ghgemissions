require 'rails_helper'

RSpec.describe ClearedOffer, type: :model do
  before(:all) do
    @cleared_offer1 = FactoryBot.create(:cleared_offer)
  end

  it 'is valid with valid attributes' do
    expect(@cleared_offer1).to be_valid
  end

  it 'invalidates records with no date' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, date: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with no trading period' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, trading_period: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with non integer trading periods' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, trading_period: 'a')
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with trading periods less than 1' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, trading_period: 0)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with trading periods greater than 50' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, trading_period: 51)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with no island' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, island: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with an invalid island' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, island: 'WE')
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with no poc' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, poc: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with an invalid poc' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, poc: 'GLN0332 GLN11')
    expect(cleared_offer2).to_not be_valid
  end  

  it 'invalidates records with no trader' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, trader: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with an invalid trader ID' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, trader: 'Genesis')
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with no offer type' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, offer_type: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with an invalid offer type ID' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, offer_type: 'Genesis')
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with no cleared energy' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, cleared_energy: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with a non numerical cleared energy' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, cleared_energy: 'a')
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with no emissions' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, emissions: nil)
    expect(cleared_offer2).to_not be_valid
  end

  it 'invalidates records with non numerical emissions' do
    cleared_offer2 = FactoryBot.build(:cleared_offer, emissions: 'a')
    expect(cleared_offer2).to_not be_valid
  end 
end

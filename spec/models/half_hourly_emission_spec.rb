require 'rails_helper'

RSpec.describe HalfHourlyEmission, type: :model do
  before(:all) do
    @hhemission1 = FactoryBot.create(:half_hourly_emission)
  end

  it 'is valid with valid attributes' do
    expect(@hhemission1).to be_valid
  end

  it 'invalidates records with no date' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, date: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with no trading period' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, trading_period: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with non integer trading periods' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, trading_period: 'a')
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with trading periods less than 1' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, trading_period: 0)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with trading periods greater than 50' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, trading_period: 51)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with no trader' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, trader: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with an invalid trader ID' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, trader: 'Genesis')
    expect(hhemission2).to_not be_valid
  end
  
  it 'invalidates records with no energy' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, energy: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with a non numerical energy' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, energy: 'a')
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with no emissions' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, emissions: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with non numerical emissions' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, emissions: 'a')
    expect(hhemission2).to_not be_valid
  end  
end

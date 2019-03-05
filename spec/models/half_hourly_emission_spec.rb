require 'rails_helper'

RSpec.describe HalfHourlyEmission, type: :model do
  before(:all) do
    @hhemission1 = FactoryBot.create(:half_hourly_emission)
    pp @hhemission1
  end

  it 'is valid with valid attributes' do
    expect(@hhemission1).to be_valid
  end

  it 'invalidates records with no month' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, month: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with non integer months' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, month: 'Jan')
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with a month less than 1' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, month: 0)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with a month greater than 12' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, month: 14)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with no period' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, period: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with periods less than 1' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, period: '0')
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with periods greater than 50' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, period: '51')
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with a non-valid period' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, period: 'wkend')
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

  it 'invalidates records with no emission factors' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, emissions_factor: nil)
    expect(hhemission2).to_not be_valid
  end

  it 'invalidates records with non numerical emission factors' do
    hhemission2 = FactoryBot.build(:half_hourly_emission, emissions_factor: 'a')
    expect(hhemission2).to_not be_valid
  end
end

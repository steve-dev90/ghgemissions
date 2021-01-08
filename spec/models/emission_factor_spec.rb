require 'rails_helper'

RSpec.describe EmissionFactor, type: :model do
  before(:all) do
    @emission_factor = FactoryBot.create(:emission_factor)
  end

  it 'is valid with valid attributes' do
    expect(@emission_factor).to be_valid
  end

  it 'invalidates records with no fuel type' do
    emission_factor2 = FactoryBot.build(:emission_factor, fuel_type: nil)
    expect(emission_factor2).to_not be_valid
  end

  it 'invalidates records with an invalid fuel type' do
    emission_factor2 = FactoryBot.build(:emission_factor, fuel_type: 'fake fuel')
    expect(emission_factor2).to_not be_valid
  end

  it 'invalidates records with no units' do
    emission_factor2 = FactoryBot.build(:emission_factor, units: nil)
    expect(emission_factor2).to_not be_valid
  end

  it 'invalidates records with an invalid units' do
    emission_factor2 = FactoryBot.build(:emission_factor, units: 'fake unit')
    expect(emission_factor2).to_not be_valid
  end

  it 'invalidates records with no emission factor' do
    emission_factor2 = FactoryBot.build(:emission_factor, factor: nil)
    expect(emission_factor2).to_not be_valid
  end

  it 'invalidates records with non numerical emission_factor' do
    emission_factor2 = FactoryBot.build(:emission_factor, factor: 'a')
    expect(emission_factor2).to_not be_valid
  end
end

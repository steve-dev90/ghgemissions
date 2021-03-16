require 'rails_helper'

RSpec.describe CoalEmissionAdjustment, type: :model do
  before(:all) do
    @coal_adjust1 = FactoryBot.build(:coal_emission_adjustment)
  end

  it 'is valid with valid attributes' do
    expect(@coal_adjust1).to be_valid
  end

  it 'invalidates records with no month' do
    coal_adjust2 = FactoryBot.build(:coal_emission_adjustment, month: nil)
    expect(coal_adjust2).to_not be_valid
  end

  it 'invalidates records with non integer months' do
    coal_adjust2 = FactoryBot.build(:coal_emission_adjustment, month: 'Jan')
    expect(coal_adjust2).to_not be_valid
  end

  it 'invalidates records with months less than 1' do
    coal_adjust2 = FactoryBot.build(:coal_emission_adjustment, month: 0)
    expect(coal_adjust2).to_not be_valid
  end

  it 'invalidates records with months greater than 12' do
    coaladjust2 = FactoryBot.build(:coal_emission_adjustment, month: 13)
    expect(coaladjust2).to_not be_valid
  end

  it 'invalidates records with no adjust_factor' do
    coaladjust2 = FactoryBot.build(:coal_emission_adjustment, adjust_factor: nil)
    expect(coaladjust2).to_not be_valid
  end

  it 'invalidates records with a adjust_factor that is not a float' do
    coal_adjust2 = FactoryBot.build(:coal_emission_adjustment, adjust_factor: 'a')
    # pp station.valid?
    # pp station.errors.messages
    expect(coal_adjust2).to_not be_valid
  end

  it 'invalidates records with a adjust_factor less than 0' do
    coal_adjust2 = FactoryBot.build(:coal_emission_adjustment, adjust_factor: -0.1)
    expect(coal_adjust2).to_not be_valid
  end

  it 'invalidates records with a adjust_factor greater than 1.0' do
    coal_adjust2 = FactoryBot.build(:coal_emission_adjustment, adjust_factor: 1.01)
    expect(coal_adjust2).to_not be_valid
  end

end

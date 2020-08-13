require 'rails_helper'

RSpec.describe AutomotiveFuelPrice, type: :model do
  before(:all) do
    @fuel_price = FactoryBot.create(:automotive_fuel_price)
  end

  it 'is valid with valid attributes' do
    expect(@fuel_price).to be_valid
  end

  it 'invalidates records with no month' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, month: nil)
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with non integer months' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, month: 'Jan')
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with a month less than 1' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, month: 0)
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with a month greater than 12' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, month: 14)
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with no fuel type' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, fuel_type: nil)
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with an invalid fuel type' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, fuel_type: 'LPG')
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with no fuel_price' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, fuel_price: nil)
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with non numerical fuel_price' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, fuel_price: 'a')
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with negative fuel_price' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, fuel_price: -2.0)
    expect(fuel_price2).to_not be_valid
  end

  it 'invalidates records with fuel_price greater than 300' do
    fuel_price2 = FactoryBot.build(:automotive_fuel_price, fuel_price: 350.0)
    expect(fuel_price2).to_not be_valid
  end

end

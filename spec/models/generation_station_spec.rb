require 'rails_helper'

RSpec.describe GenerationStation, type: :model do
  before(:all) do
    @station1 = FactoryBot.create(:generation_station)
  end

  it 'is valid with valid attributes' do
    expect(@station1).to be_valid
  end

  it 'invalidates records with no trader' do
    station2 = FactoryBot.build(:generation_station, station_name: nil)
    expect(station2).to_not be_valid
  end

  it 'invalidates records with no fuel name' do
    station2 = FactoryBot.build(:generation_station, fuel_name: nil)
    expect(station2).to_not be_valid
  end

  it 'invalidates records with an invalid fuel name' do
    station2 = FactoryBot.build(:generation_station, fuel_name: 'LPG')
    expect(station2).to_not be_valid
  end

  it 'invalidates records with no generation_type' do
    station2 = FactoryBot.build(:generation_station, generation_type: nil)
    expect(station2).to_not be_valid
  end

  it 'invalidates records with no primary efficiency' do
    station2 = FactoryBot.build(:generation_station, primary_efficiency: nil)
    expect(station2).to_not be_valid
  end

  it 'invalidates records with non numerical primary efficiency' do
    station2 = FactoryBot.build(:generation_station, primary_efficiency: 'a')
    expect(station2).to_not be_valid
  end

  it 'invalidates records with emissions factor less than 0.0' do
    station2 = FactoryBot.build(:generation_station, emissions_factor: -0.2)
    expect(station2).to_not be_valid
  end

  it 'invalidates records with emissions factor greater than 1.1' do
    station2 = FactoryBot.build(:generation_station, emissions_factor: 1.12)
    expect(station2).to_not be_valid
  end
end

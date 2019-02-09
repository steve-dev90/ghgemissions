require 'rails_helper'

RSpec.describe Power::GenerationData do
  before(:all) do
    GenerationStation.destroy_all
    @stations = Power::GenerationData.new('./spec/services/power/existing_generating_plant_test.xlsx')
    @stations.call
  end

  it 'uploads the correct number of records' do
    expect(GenerationStation.count).to eq(6)
  end

  it 'only include power stations that use gas, coal, diesel or geothermal' do
    expect(GenerationStation.pluck(:fuel_name)).to include('Geothermal', 'Coal_NI', 'Gas', 'Diesel')
  end

  it 'does not include embedded power stations' do
    expect(GenerationStation.pluck(:station_name)).to_not include('Addington', 'Amethyst', 'Bay Milk Edgecumbe',
                                                                  'Blue Mountain Lumber',
                                                                  'Christchurch City Wastewater')
  end

  it 'calculates emissions factors for geothermal power stations correctly' do
    expect(GenerationStation.where(generation_type: 'Geothermal').pluck(:emissions_factor)).to include(eq(0.1))
  end

  it 'calculates emissions factors for gas power stations correctly' do
    expected = (10_000.0 * 53.96 / 10**6).round(6)
    expect(GenerationStation.where(station_name: 'McKee').first[:emissions_factor].round(6)).to eq(expected)
  end

  it 'calculates emissions factors for coal power stations correctly' do
    expected = 10_300.0 * 92.2 / 10**6
    expect(GenerationStation.where(station_name: 'Huntly').first[:emissions_factor]).to eq(expected)
  end

  it 'calculate emissions factors for gas power stations that are not thermal and have 0 primary efficiency' do
    expect(GenerationStation.where(station_name: 'Te Rapa').first[:emissions_factor]).to eq(0.0)
  end

  it 'only includes power stations with a full poc' do
    expect(GenerationStation.pluck(:poc)).to_not include('', nil)
  end
end

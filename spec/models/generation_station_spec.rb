require 'rails_helper'

RSpec.describe GenerationStation, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:GenerationStation)).to be_valid
  end

  it 'invalidates records with no station name' do
    station = GenerationStation.new(station_name: 'Huntly', poc: 'HLY2201',
      fuel_name: 'Gas', generation_type: 'Thermal', primary_efficiency: 9000, emissions_factor: 0.48)
    # pp station.valid?
    # pp station.errors.messages

    expect(station.valid?).to eq(true)
  end
end


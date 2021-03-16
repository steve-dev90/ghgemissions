require 'rails_helper'

RSpec.describe Power::ClearedOfferData do
  before(:all) do
    GenerationStation.destroy_all
    FactoryBot.create(:generation_station)
    FactoryBot.create(:generation_station, poc: 'WRK2201 WRK0', emissions_factor: 0.1, fuel_name: 'geothermal')
    FactoryBot.create(:generation_station, poc: 'HLY2201 HLY3', emissions_factor: 0.48)
    FactoryBot.create(:generation_station, poc: 'ROX1101 ROX0', emissions_factor: 0, fuel_name: 'hydro')
    FactoryBot.create(:generation_station, poc: 'AVI1201 AVI0', emissions_factor: 0, fuel_name: 'wind')
    HalfHourlyEmission.destroy_all
    @cleared_offer = Power::ClearedOfferData.new('./spec/services/power/Cleared_Offers_Test_Data/*')
    @cleared_offer.call
    HalfHourlyEmission.all
  end

  it 'saves the correct month' do
    pp HalfHourlyEmission.all
    expect(HalfHourlyEmission.find_by(period: 1)[:month]).to eq(11)
    expect(HalfHourlyEmission.find_by(period: 2)[:month]).to eq(11)
    expect(HalfHourlyEmission.where(period: 20).pluck(:month)).to eq([9, 10])
  end

  it 'saves the correct fuel_type' do
    expect(HalfHourlyEmission.where(period: 1).pluck(:fuel_type)).to include('geothermal', 'natural_gas')
    expect(HalfHourlyEmission.where(period: 1).count).to eq(2)
  end

  # it 'calculates the correct energy for each trading period' do
  #   # Total all cleared energy over both trading days and convert to MWh
  #   expect(HalfHourlyEmission.find_by(period: 1, month: 11)[:energy]).to eq((450 + 350 + 50) * 0.5)
  #   # Total cleared energy for a trading period should be the same for each trader
  #   expect(HalfHourlyEmission.where(period: 1, month: 11).distinct.pluck(:energy).size).to eq(1)
  #   expect(HalfHourlyEmission.find_by(period: 2, month: 11)[:energy]).to eq((250 + 450) * 0.5)
  #   expect(HalfHourlyEmission.where(period: 1, month: 11).distinct.pluck(:energy).size).to eq(1)
  #   expect(HalfHourlyEmission.find_by(period: 20, month: 9)[:energy]).to eq(50 * 0.5)
  #   expect(HalfHourlyEmission.find_by(period: 20, month: 10)[:energy]).to eq(50 * 0.5)
  # end

  # it 'calculates the correct emissions' do
  #   # Trader emissions is trader energy for stations that emit converted to MWh multipled by the emissions factor
  #   expect(HalfHourlyEmission.find_by(period: 1, month: 11, trader: 'GENE')[:emissions]).to eq(450 * 0.5 * 0.48)
  #   expect(HalfHourlyEmission.find_by(period: 2, month: 11, trader: 'CTCT')[:emissions]).to eq(150 * 0.5 * 0.1)
  #   expect(HalfHourlyEmission.find_by(period: 2, month: 11, trader: 'MERI')).to be_nil
  #   expect(HalfHourlyEmission.find_by(period: 20, month: 9, trader: 'GENE')[:emissions]).to eq(50 * 0.5 * 0.48)
  # end

  # it 'calculates the correct emissions factor' do
  #   expect(HalfHourlyEmission.find_by(period: 1, month: 11, trader:'GENE')[:emissions_factor]).to be_within(0.0001).of(450 * 0.5 * 0.48 / 425)
  #   expect(HalfHourlyEmission.find_by(period: 2, month: 11, trader:'CTCT')[:emissions_factor]).to be_within(0.0001).of(150 * 0.5 * 0.1 / 350)
  #   expect(HalfHourlyEmission.find_by(period: 20, month: 9, trader:'GENE')[:emissions_factor]).to be_within(0.0001).of(50 * 0.5 * 0.48 / 25)
  # end

  # it 'does not save records with zero emissions' do
  #   expect(HalfHourlyEmission.find_by(emissions_factor: 0.0)).to be_nil
  # end

  # it 'raises an error for unknown pocs' do
  #   HalfHourlyEmission.destroy_all
  #   file = './spec/services/power/Cleared_Offers_Test_Data_Unknown_POC/Cleared_Offers_test_unknown_poc.csv'
  #   csv = CSV.read(file, converters: :numeric, headers:true)
  #   process_file = Power::ProcessClearedOfferCSV.new(csv, HalfHourlyEmission)
  #   expect { process_file.call}.to raise_error(RuntimeError, 'Point of connection does not exist, poc: HLY3201 HLY1')
  # end
end

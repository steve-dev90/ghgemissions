require 'rails_helper'

RSpec.describe Power::GenerationData do
  before(:all) do
    EmissionFactor.destroy_all
    FactoryBot.create(:emission_factor, fuel_type: 'natural_gas', units: 'tCO2/TJ', factor: 53.96)
    FactoryBot.create(:emission_factor, fuel_type: 'coal', units: 'tCO2/TJ', factor: 92.2)
    FactoryBot.create(:emission_factor, fuel_type: 'diesel', units: 'tCO2/TJ', factor: 69.69)
    GenerationStation.destroy_all
    @stations = Power::GenerationData.new(
      './spec/services/power/existing_generating_plant_test_v2.xlsx',
      'Generating Stations')
    @stations.call
  end

  it 'uploads the correct number of records' do
    expect(GenerationStation.count).to eq(18)
  end

  it 'calculates emissions factors for geothermal power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'geothermal').sum(:emissions_factor)).to be_within(0.0001).of(0.7120)
  end

  it 'calculates emissions factors for gas power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'natural_gas').sum(:emissions_factor)).to be_within(0.0001).of(2.059151)
  end

  it 'calculates emissions factors for coal power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'coal').sum(:emissions_factor)).to be_within(0.0001).of(3.01494)
  end

  it 'calculate emissions factors for wood waste power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'wood_waste').sum(:emissions_factor)).to eq(0.0)
  end

  it 'calculate emissions factors for process waste power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'process_waste').sum(:emissions_factor)).to eq(0.0)
  end

  it 'calculate emissions factors for wind power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'wind').sum(:emissions_factor)).to eq(0.0)
  end

  it 'calculate emissions factors for hydro power stations correctly' do
    expect(GenerationStation.where(fuel_name: 'hydro').sum(:emissions_factor)).to eq(0.0)
  end

  it 'throws an exception if a thermal power station has no heat rate' do
    GenerationStation.destroy_all
    @stations = Power::GenerationData.new(
      './spec/services/power/existing_generating_plant_test_v2.xlsx',
      'NoHeatRate')
    expect { @stations.call }.to raise_error(RuntimeError, 'thermal fuel has no heat rate')
  end

  it 'throws an exception if a thermal power station has an unreasonable heat rate' do
    GenerationStation.destroy_all
    @stations = Power::GenerationData.new(
      './spec/services/power/existing_generating_plant_test_v2.xlsx',
      'HeatRateWrong')
    expect { @stations.call }.to raise_error(RuntimeError, 'thermal fuel heat rate out of bounds')
  end

  it 'throws an exception if a geothermal power station has no emissions factor' do
    GenerationStation.destroy_all
    @stations = Power::GenerationData.new(
      './spec/services/power/existing_generating_plant_test_v2.xlsx',
      'NoEmissFact')
    expect { @stations.call }.to raise_error(RuntimeError, 'geothermal has no emissions factor')
  end

  it 'throws an exception if a geothermal power station has an unreasonble emissions factor' do
    GenerationStation.destroy_all
    @stations = Power::GenerationData.new(
      './spec/services/power/existing_generating_plant_test_v2.xlsx',
      'EmissFactWrong')
    expect { @stations.call }.to raise_error(RuntimeError, 'geothermal emissions factor out of bounds')
  end
end

require 'rails_helper'

RSpec.describe Energy::RawProfileData do
  before(:all) do
    # Nothing
  end

  it 'processes a GIC gas profile file - whole year' do
    input_path = './spec/services/energy/GIC_Profile_Test_Full_Year.txt'
    output_path = './spec/services/energy/BEL24510full.csv'
    profile_loc = 'BEL24510'
    data_processor = Gas::GasProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
    output_csv = CSV.read(output_path, converters: :numeric)
    expect(output_csv.length).to eq(365)
    expect(output_csv.map { |row| row[1] }.uniq).to eq(['BEL24510'])
  end

  it 'processes a GIC gas profile file - part year' do
    input_path = './spec/services/energy/GIC_Profile_Test_Part_Year.txt'
    output_path = './spec/services/energy/BEL24510part.csv'
    profile_loc = 'BEL24510'
    data_processor = Gas::GasProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
    output_csv = CSV.read(output_path, converters: :numeric)
    expect(output_csv.length).to eq(365)
    expect(output_csv.map { |row| row[1] }.uniq).to eq(['BEL24510'])
  end

  it 'processes a folder of EA power profiles' do
    input_path = "./spec/services/energy/profile_data/*"
    output_path = './spec/services/energy/CPK0111full.csv'
    profile_loc = 'CPK0111'
    data_processor = Power::PowerProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
    output_csv = CSV.read(output_path, converters: :numeric)
    expect(output_csv.length).to eq(24)
  end
end

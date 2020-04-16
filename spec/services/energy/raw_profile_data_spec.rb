require 'rails_helper'

RSpec.describe Energy::RawProfileData do
  before(:all) do
    # Nothing
  end

  it 'does it work - gas' do
    input_path = './spec/services/energy/GIC_Profile_Test_Full_Year.txt'
    output_path = './spec/services/energy/BEL24510.csv'
    profile_loc = 'BEL24510'
    data_processor = Gas::GasProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
  end

  it 'does it work - power' do
    skip
    input_path = "./lib/assets/profile_data/*"
    output_path = './spec/services/energy/CPK0111_RPS.csv'
    profile_loc = 'CPK0111'
    data_processor = Power::PowerProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
  end

end

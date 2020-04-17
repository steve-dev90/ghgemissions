namespace :gas do
  desc 'Process raw GIC gas profiles'
  task process_raw_GIC_profiles: :environment do
    input_path = './lib/assets/ALLA_G_GASW_GAR060_201912_20200108_141506.txt'
    output_path = './lib/assets/BEL24510.csv'
    profile_loc = 'BEL24510'
    data_processor = Gas::GasProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
  end
end
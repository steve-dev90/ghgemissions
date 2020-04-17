namespace :power do
  desc 'Keep only CPK0111 GXP profile data'
  # THIS NEEDS UPDATING
  task process_rps_csvs: :environment do
    input_path = "./lib/assets/profile_data/*"
    output_path = './lib/assets/CPK0111_RPS.csv'
    profile_loc = 'CPK0111'
    data_processor = Power::PowerProfileProcessor.new
    raw_profile = Energy::RawProfileData.new(data_processor, input_path, output_path, profile_loc)
    raw_profile.call
  end
end
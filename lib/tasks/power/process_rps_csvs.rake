namespace :power do
  desc 'Keep only CPK0111 GXP profile data'
  # THIS NEEDS UPDATING
  task process_rps_csvs: :environment do
    process_rps = Power::ProcessRps.new("./lib/assets/profile_data/*")
    process_rps.call
  end
end
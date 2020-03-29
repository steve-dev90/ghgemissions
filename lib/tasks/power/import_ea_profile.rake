namespace :power do
  desc 'Import EA rps profile for GXP CPK0111 stored in spreadsheet'
  task import_ea_profile: :environment do
    profile = Energy::ProfileData.new('./spec/services/power/CPK0111_RPS_Test.csv', &POWER_TRADING_PERIOD_PROCESSOR)
    profile.call
  end
end

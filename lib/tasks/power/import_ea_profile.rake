namespace :power do
  desc 'Import EA rps profile for GXP CPK0111 stored in spreadsheet'
  task import_ea_profile: :environment do
    profile = Energy::ProfileData.new('./lib/assets/CPK0111_RPS.csv', 'power', &POWER_TRADING_PERIOD_PROCESSOR)
    profile.call
  end
end

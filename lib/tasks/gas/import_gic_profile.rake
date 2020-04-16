namespace :gas do
  desc 'Import GIC profile for Gas Gate BEL24510 stored in spreadsheet'
  task import_ea_profile: :environment do
    energy_type = EnergyType.where(name: 'power').first.id
    profile = Energy::ProfileData.new('./spec/services/power/CPK0111_RPS_Test.csv', energy_type, &POWER_TRADING_PERIOD_PROCESSOR)
    profile.call
  end
end
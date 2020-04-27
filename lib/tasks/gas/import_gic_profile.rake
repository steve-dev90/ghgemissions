namespace :gas do
  desc 'Import GIC profile for Gas Gate BEL24510 stored in spreadsheet'
  task import_GIC_profile: :environment do
    profile = Energy::ProfileData.new('./lib/assets/BEL24510.csv', 'gas', &GAS_TRADING_PERIOD_PROCESSOR)
    profile.call
  end
end
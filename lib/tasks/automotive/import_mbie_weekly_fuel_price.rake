namespace :automotive do
  desc 'Import MBIE weekly fuel price csv'
  task import_mbie_weekly_fuel_price: :environment do
    pp "Hello"
    fuel_data = Automotive::ProcessWeeklyFuelData.new('test')
    fuel_data.call
  end
end
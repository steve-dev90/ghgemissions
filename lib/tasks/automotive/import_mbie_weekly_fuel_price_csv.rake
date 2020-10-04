namespace :automotive do
  desc 'Import MBIE weekly fuel price csv from lib folder'
  task import_mbie_weekly_fuel_price_csv: :environment do
    file = './lib/assets/weekly-table.csv'
    data = CSV.read(file, converters: :numeric, headers:true)
    weekly_fuel_data = Automotive::ProcessWeeklyFuelData.new(data)
    weekly_fuel_data.call
  end
end
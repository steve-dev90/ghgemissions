namespace :automotive do
  desc 'Import MBIE weekly fuel price from MBIE website'
  task import_mbie_weekly_fuel_price: :environment do
    fuel_data = Automotive::FuelDataMbie.new
    fuel_data.call
  end
end
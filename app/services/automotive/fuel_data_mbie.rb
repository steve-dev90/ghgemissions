class Automotive::FuelDataMbie
  def call
    # HTTParty returns an array of csv rows
    data = HTTParty.get("https://www.mbie.govt.nz/assets/Data-Files/Energy/Weekly-fuel-price-monitoring/weekly-table.csv")
    # Get rid of the header row
    data.shift()
    raise "Empty MBIE weekly fuel file" if data.empty?
    weekly_fuel_data = Automotive::ProcessWeeklyFuelData.new(data)
    weekly_fuel_data.call
  rescue RuntimeError, ArgumentError => error
    pp error
  end
end
class Automotive::ProcessWeeklyFuelData
  def initialize(file)
    @file = file
  end

  # This method assumes there is only one file per trading date
  def call
    pp "hello"
    begin
      csv = CSV.read(@file, converters: :numeric, headers:true)
      pp csv[5]
      if csv[0].nil?
        raise 'File is empty'
        # break
      end
      puts "File: #{@file} CSV read completed"
      obtain_monthly_average_fuel_prices
      save_records
      pp csv
        # obtain_half_hourly_emission_records(csv)
        # save_records
    rescue RuntimeError => e
      puts "#{e.class}: #{e.message}"
    end
    puts 'Automotive fuel file processed!'
  end

  def obtain_monthly_average_fuel_prices
    months = [Time.now, Time.now.prev_month, Time.now.prev_month.prev_month].map { |m| m.month}
  end

  def save_records
  end
end

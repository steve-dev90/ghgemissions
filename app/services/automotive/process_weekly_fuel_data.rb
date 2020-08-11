class Automotive::ProcessWeeklyFuelData
  RATIO_PREMIUM_PETROL_PRICE_REGULAR_PETROL_PRICE = 1.06

  def initialize(file)
    @file = file
  end

  # This method assumes there is only one file per trading date
  def call
    pp "hello"
    begin
      csv = CSV.read(@file, converters: :numeric, headers:true)
      if csv[0].nil?
        raise 'File is empty'
        # break
      end
      puts "File: #{@file} CSV read completed"
      pp Date.parse(csv[0]['Week_ending_Friday']).month
      get_last_three_months.each do |month|
        pp month
        rows = csv.select { |row| Date.parse(row['Week_ending_Friday']).month == month }
        # pp rows
        pp get_monthly_record(rows, month)
        # save_records(get_monthly_record(rows, month))
      end
        # obtain_half_hourly_emission_records(csv)
        # save_records
    rescue RuntimeError => e
      puts "#{e.class}: #{e.message}"
    end
    puts 'Automotive fuel file processed!'
  end

  def get_last_three_months
    months = [Time.now, Time.now.prev_month, Time.now.prev_month.prev_month].map { |m| m.month}
  end

  def get_monthly_record(rows, month)
     [{ month: month,
        fuel_type: 'diesel',
        fuel_price: average_fuel_price(rows, 'Diesel_discounted_retail_price_NZc.p.l') },
      { month: month,
        fuel_type: 'regular_petrol',
        regulur_petrol_price: average_fuel_price(rows, 'Regular_Petrol_discounted_retail_price_NZc.p.l') },
      { month: month,
        fuel_type: 'premium_petrol',
        premium_petrol_price: average_fuel_price(rows, 'Regular_Petrol_discounted_retail_price_NZc.p.l')  &&
                            average_fuel_price(rows, 'Regular_Petrol_discounted_retail_price_NZc.p.l') * RATIO_PREMIUM_PETROL_PRICE_REGULAR_PETROL_PRICE }]
  end

  def average_fuel_price(rows, fuel_name)
    month_sum = rows.sum{ |r| r[fuel_name] }
    month_sum / rows.size.to_f unless month_sum.zero?
  end

  def save_records
  end
end

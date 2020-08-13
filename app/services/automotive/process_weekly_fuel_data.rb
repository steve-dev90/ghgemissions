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
      # delete previous records

      get_last_three_months.each do |month|
        rows = csv.select { |row| Date.parse(row['Week_ending_Friday']).month == month }
        save_records(get_monthly_record(rows, month))
      end

      pp AutomotiveFuelPrice.all

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
        fuel_price: average_fuel_price(rows, 'Regular_Petrol_discounted_retail_price_NZc.p.l') },
      { month: month,
        fuel_type: 'premium_petrol',
        fuel_price: average_fuel_price(rows, 'Regular_Petrol_discounted_retail_price_NZc.p.l')  &&
                            average_fuel_price(rows, 'Regular_Petrol_discounted_retail_price_NZc.p.l') * RATIO_PREMIUM_PETROL_PRICE_REGULAR_PETROL_PRICE }]
  end

  def average_fuel_price(rows, fuel_name)
    month_sum = rows.sum{ |r| r[fuel_name] }
    month_sum / rows.size.to_f unless month_sum.zero?
  end

  def save_records(records)
    records.each do |record|
      automative_fuel_record = AutomotiveFuelPrice.find_or_create_by(month: record[:month], fuel_type: record[:fuel_type], fuel_price: record[:fuel_price])
      pp '*** Record not Valid ***', record, automative_fuel_record.errors.messages unless automative_fuel_record.update(record)
    end
  end
end

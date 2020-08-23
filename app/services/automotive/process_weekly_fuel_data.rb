class Automotive::ProcessWeeklyFuelData
  RATIO_PREMIUM_PETROL_PRICE_REGULAR_PETROL_PRICE = 1.06

  def initialize(fuel_data)
    @fuel_data = fuel_data
  end

  def call
    AutomotiveFuelPrice.delete_all

    get_last_three_months.each do |month|
      rows =  @fuel_data.select do |row|
                Date.parse(row[0]).month == month.month &&
                Date.parse(row[0]).year == month.year
              end
      save_records(get_monthly_record(rows, month))
    end

    pp AutomotiveFuelPrice.all
    puts 'Automotive fuel file processed!'
  end

  def get_last_three_months
    lastest_date = Date.parse(@fuel_data.map{|r| r[0]}.sort.last)
    latest_month_beginning = Date.new(lastest_date.year, lastest_date.month, 1)
    [latest_month_beginning, latest_month_beginning.prev_month, latest_month_beginning.prev_month.prev_month]
  end

  def get_monthly_record(rows, month)
     [{ month_beginning: month,
        fuel_type: 'diesel',
        fuel_price: average_fuel_price(rows, 12) },
      { month_beginning: month,
        fuel_type: 'regular_petrol',
        fuel_price: average_fuel_price(rows, 21) },
      { month_beginning: month,
        fuel_type: 'premium_petrol',
        fuel_price: average_fuel_price(rows, 21)  &&
                    average_fuel_price(rows, 21) * RATIO_PREMIUM_PETROL_PRICE_REGULAR_PETROL_PRICE }]
  end

  def average_fuel_price(rows, col_index)
    month_sum = rows.sum{ |r| r[col_index].to_f }
    month_sum / rows.size.to_f unless month_sum.zero?
  end

  def save_records(records)
    records.each do |record|
      automative_fuel_record = AutomotiveFuelPrice.find_or_create_by(month_beginning: record[:month_beginning], fuel_type: record[:fuel_type], fuel_price: record[:fuel_price])
      raise "Fuel record not valid #{record} #{automative_fuel_record.errors.messages}" unless automative_fuel_record.update(record)
    end
  end
end

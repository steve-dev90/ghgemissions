class Gas::GasProfileProcessor
  def process_raw_profile_data(context)
    @csv = CSV.read(context.input_path, converters: :numeric, headers: true)
    max_year = find_max_year
    max_month = find_max_month(max_year)
    pp @csv
      .map { |row| row[3] }
    @csv
      .select { |row| row_test(row, max_year, max_month, context.profile_loc)}
      .each do |row|
        context.write_to_csv(row)
      end
  end

  def find_max_year
    @csv.map { |row| Date.parse(row[3]).year }.max
  end

  def find_max_month(max_year)
    # Find the latest month that corresponds to max_year
    @csv
      .select { |row| Date.parse(row[3]).year == max_year }
      .map { |row| Date.parse(row[3]).month }
      .max
  end

  def row_test(row, max_year, max_month, profile_loc)
    row_year = Date.parse(row[3]).year
    location_test = row[1] == profile_loc
    max_year_test = row_year == max_year
    return location_test && max_year_test if max_month == 12

    max_year_minus_one_test = row_year == (max_year - 1) &&  Date.parse(row[3]).month > max_month
    location_test && (max_year_test || max_year_minus_one_test)
  end
end
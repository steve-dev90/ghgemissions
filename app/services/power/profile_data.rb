class Power::ProfileData
  def initialize(file)
    @file = file
    @profile_records = []
  end

  def call
    csv = CSV.read(@file, converters: :numeric)
    obtain_profile_records(csv)
    pp @profile_records
  end

  def obtain_profile_records(csv)
    profile_annual_sum = csv.sum { |row| row[5] }
    months = csv.map { |row| Date.parse(row[3]).month }.uniq
    months.each do |month|
      profile_monthly_sum = profile_monthly_sum(csv, month)
      pp 'Hello', profile_monthly_sum
      monthly_profile = profile_monthly_sum / profile_annual_sum
      @profile_records << {month: month, profile: monthly_profile, period: 'month'}
      add_trading_period_profile_records(csv, profile_monthly_sum, month)
      add_wkend_night_profile_records(csv, profile_monthly_sum, month)
    end
  end

  def profile_monthly_sum(csv, month)
    csv
      .select { |row| Date.parse(row[3]).month == month }
      .sum { |row| row[5]}
  end

  def add_trading_period_profile_records(csv, profile_monthly_sum, month)
    trading_periods = csv.map { |row| row[4] }.uniq
    trading_periods.each do |trading_period|
      profile_trading_period_sum = trading_period_profile_sum(csv, month, trading_period)
      trading_period_profile = profile_trading_period_sum / profile_monthly_sum
      @profile_records << {month: month, profile: trading_period_profile, period: trading_period.to_s}
    end
  end

  def trading_period_profile_sum(csv, month, trading_period)
    csv
     .select { |row| Date.parse(row[3]).month == month && row[4] == trading_period }
     .sum { |row| row[5]}
  end

  def add_wkend_night_profile_records(csv, profile_monthly_sum, month)
    profile_wkend_night_sum = csv
      .select { |row| Date.parse(row[3]).month == month && (row[4] < 15 || row[4] > 19) }
      .sum { |row| row[5]}
    wkend_night_profile = profile_wkend_night_sum / profile_monthly_sum
    @profile_records << {month: month, profile: wkend_night_profile, period: 'wkend-night'}
  end


  # def obtain_profile_records
  #   CSV.foreach(@file, converters: :numeric) do |row|
  #     record = extract_record(row)
  #     hash_record = { month: record[:month], profile: record[:profile] }
  #     # create_or_update_profile_record(record[:month], 'month', hash_record)
  #     # create_or_update_profile_record(record[:month], record[:trading_period], hash_record)
  #     # create_or_update_profile_record(record[:month], record[:period], hash_record)
  #   end
  # end

  # def extract_record(row)
  #   date = Date.parse(row[3])
  #   wkend = date.saturday? || date.sunday
  #   # Day is deemed from 7 am (tp = 15) to 7 pm ( tp = 39)
  #   day = row[4] >= 15 && row[4] <= 19
  #   period = 'wkend-day' if wkend && day
  #   period = 'wkend-night' if wkend && !day
  #   period = 'wkday-day' if !wkend && day
  #   period = 'wkday-night' if !wkend && !day
  #   { trading_period: row[4],
  #     profile: row[5],
  #     month: date.month,
  #     period: period
  #   }
  # end

  # def create_or_update_profile_record(month, period, hash_record)
  #   index = @profile_records.index do |profile_record|
  #     profile_record[:month] == month && profile_record[:period] == period
  #   end
  #   if index.nil?
  #     @profile_records << hash_record.merge(period: period)
  #   else
  #     @profile_records[index][:profile] += hash_record[:profile]
  #   end
  # end

  # def update_record(index, record)
  #   @profile_records[index][:profile] += record[:profile]
  # end

  # def obtain_profile_sum
  #   @profile_records.sum { |record| record[:profile] }
  # end

  # def divide_profile_by_total_profile
  #   pp sum = obtain_profile_sum
  #   @profile_records.each { |record| record[:profile] = record[:profile] / sum }
  # end

  # def save_records
  #   @profile_records.each do |record|
  #     profile = Profile.find_or_create_by(trading_period: record[:trading_period])
  #     pp '*** Record not Valid ***', record, profile.errors.messages unless profile.update_attributes(record)
  #   end
  # end
end

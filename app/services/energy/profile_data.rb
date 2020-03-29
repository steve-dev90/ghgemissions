POWER_TRADING_PERIOD_PROCESSOR = lambda do |csv, profile_monthly_sum, month, context|
  #Where `context` is the current ProfileData object
  trading_periods = csv.select { |row| context.profile_test(row, month, 'month') }.map { |row| row[4] }.uniq
  trading_periods.each do |trading_period|
    context.add_profile_records(csv, profile_monthly_sum, month, trading_period.to_s)
  end
end

class Energy::ProfileData
  #This uses the strategy pattern to allow code sharing between
  #gas and power
  #This is the context object for extracting profile data from a csv
  #and saving this to the database.
  # ** At present only run at setup **
  PERIOD_TYPES = %w[ wkday wkend ].freeze

  def initialize(file, &trading_period_processor)
    @file = file
    @profile_records = []
    @trading_period_processor = trading_period_processor
  end

  def call
    csv = CSV.read(@file, converters: :numeric)
    puts "CSV #{@file} read complete"
    obtain_profile_records_all_months(csv)
    pp @profile_records
    save_records
    puts 'Records saved to database'
  end

  def obtain_profile_records_all_months(csv)
    profile_annual_sum = csv.sum { |row| row[5] }
    months = csv.map { |row| Date.parse(row[3]).month }.uniq
    months.each do |month|
      obtain_monthly_profile_records(csv, month, profile_annual_sum)
    end
  end

  def obtain_monthly_profile_records(csv, month, profile_annual_sum)
    profile_monthly_sum = profile_monthly_sum(csv, month)
    add_profile_records(csv, profile_annual_sum, month, 'month')
    @trading_period_processor.call(csv, profile_monthly_sum, month, self)
    PERIOD_TYPES.each { |period| add_profile_records(csv, profile_monthly_sum, month, period) }
    puts "Processed month #{month}!"
  end

  def profile_monthly_sum(csv, month)
    csv
      .select { |row| profile_test(row, month, 'month') }
      .sum { |row| row[5]}
  end

  def add_profile_records(csv, profile_sum, month, period)
    profile = csv
                .select { |row| profile_test(row, month, period) }
                .sum { |row| row[5]} / profile_sum
    @profile_records << {month: month, profile: profile, period: period}
  end

  def profile_test(row, month, period)
    month_test = Date.parse(row[3]).month == month
    wkend_test = Date.parse(row[3]).saturday? || Date.parse(row[3]).sunday?
    return month_test && wkend_test if period == 'wkend'
    return month_test && !wkend_test if period == 'wkday'
    return month_test if period == 'month' if period == 'month'
    month_test && row[4] == period.to_i
  end

  def save_records
    pp "saving records"
    @profile_records.each do |record|
      profile = Profile.find_or_create_by(period: record[:period], month: record[:month])
      pp '*** Record not Valid ***', record, profile.errors.messages unless profile.update_attributes(record)
    end
  end
end


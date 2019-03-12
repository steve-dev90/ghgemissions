class Power::ProfileData
  PERIOD_TYPES = %w[ wkday wkend ].freeze

  def initialize(file)
    @file = file
    @profile_records = []
  end

  def call
    csv = CSV.read(@file, converters: :numeric)
    obtain_profile_records(csv)
    pp @profile_records
    save_records
  end

  def obtain_profile_records(csv)
    profile_annual_sum = csv.sum { |row| row[5] }
    months = csv.map { |row| Date.parse(row[3]).month }.uniq
    months.each do |month|
      profile_monthly_sum = profile_monthly_sum(csv, month)
      add_profile_records(csv, profile_annual_sum, month, 'month')
      add_trading_period_profile_records(csv, profile_monthly_sum, month)
      PERIOD_TYPES.each { |period| add_profile_records(csv, profile_monthly_sum, month, period) }
    end
  end

  def profile_monthly_sum(csv, month)
    csv
      .select { |row| profile_test(row, month, 'month') }
      .sum { |row| row[5]}
  end

  def add_trading_period_profile_records(csv, profile_monthly_sum, month)
    trading_periods = csv.map { |row| row[4] }.uniq
    trading_periods.each do |trading_period|
      add_profile_records(csv, profile_monthly_sum, month, trading_period.to_s)
    end
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
    @profile_records.each do |record|
      profile = Profile.find_or_create_by(period: record[:period], month: record[:month])
      pp '*** Record not Valid ***', record, profile.errors.messages unless profile.update_attributes(record)
    end
  end
end

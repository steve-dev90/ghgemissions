class Power::ProfileData
  def initialize(file)
    @file = file
    @profile_records = []
  end

  # Day is deemed from 7 am (tp = 15) to 7 pm ( tp = 39)

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
    # profile_wkend_night_sum = csv
    #   .select { |row| Date.parse(row[3]).month == month && (row[4] < 15 || row[4] > 19) }
    #   .sum { |row| row[5]}
    # wkend_night_profile = profile_wkend_night_sum / profile_monthly_sum
    # @profile_records << {month: month, profile: wkend_night_profile, period: 'wkend_night'}
    add_profile_records(csv, profile_monthly_sum, month, 'wkend_night')

  end

  def add_profile_records(csv, profile_sum, month, period)
    profile = csv
                .select { |row| profile_test(row, month, period) }
                .sum { |row| row[5]} / profile_sum
    @profile_records << {month: month, profile: profile, period: period}
  end

  def profile_test(row, month, period)
    Date.parse(row[3]).month == month && (row[4] < 15 || row[4] > 19) if period == 'wkend_night'
  end

  def save_records
    @profile_records.each do |record|
      profile = Profile.find_or_create_by(period: record[:period], month: record[:month])
      pp '*** Record not Valid ***', record, profile.errors.messages unless profile.update_attributes(record)
    end
  end
end

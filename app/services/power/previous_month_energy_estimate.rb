class Power::PreviousMonthEnergyEstimate
  def initialize(billed_energy, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @billed_energy = billed_energy
  end

  def call
    (Date.parse(@start_date).month .. Date.parse(@end_date).month).each do |month|

    end
    # Consider using rails time
    pp 'start_factor', find_start_month_factor
  end

  def find_start_month_factor
    year = Date.parse(@start_date).year
    month = Date.parse(@start_date).month
    month_end_day = Date.new(year, month, -1)
    month_start_day = Date.new(year, month, 1)
    bill_start_day = Date.new(year, month, Date.parse(@start_date).day)
    bill_wkend_days = find_wkend_day(bill_start_day, month_end_day)
    bill_wkday_days = month_end_day.day - bill_start_day.day + 1 - bill_wkend_days
    month_wkend_days = find_wkend_day(month_start_day, month_end_day)
    month_wkday_days = month_end_day.day - month_wkend_days
    get_profile(month, 'month') * (
      get_profile(month, 'wkend') * (bill_wkend_days.to_f / month_wkend_days.to_f) +
      get_profile(month, 'wkday') * (bill_wkday_days.to_f / month_wkday_days.to_f)
      )
  end

  def get_profile(month, period)
    Profile
      .where("profiles.month = ? AND profiles.period = ?", month, period)
      .pluck(:profile)
      .first
  end

  # From https://snipplr.com/view/55546/
  def find_wkend_day(d1, d2)
    wkdays = [1,2,3,4,5] #weekend days by numbers on week
    (d1..d2).reject { |d| wkdays.include?(d.wday) }.count #Day.wday number day in week
  end

end
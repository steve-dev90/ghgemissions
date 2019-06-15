class Power::PreviousMonthEnergyEstimate
  def initialize(billed_energy, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @billed_energy = billed_energy
  end

  def call
    start_month = Date.parse(@start_date).month
    end_month = Date.parse(@end_date).month
    @billed_energy * get_profile(Date.parse(Time.new.to_s).prev_month.month, 'month') /
      (partial_month_factors(start_month, end_month) + full_month_factors(start_month, end_month))
  end

  def partial_month_factors(start_month, end_month)
    return month_factor(@start_date, MonthFactor.new, @end_date) if start_month == end_month
    month_factor(@start_date, StartMonthFactor.new, @end_date) +
    month_factor(@end_date, EndMonthFactor.new, @end_date)
  end

  def month_factor(date, factor_type, end_date)
    month = Date.parse(date).month
    dayfactor = DayFactor.new(date, factor_type, end_date)
    get_profile(month, 'month') * (
      get_profile(month, 'wkend') * dayfactor.wkend_factor +
      get_profile(month, 'wkday') * dayfactor.wkday_factor
    )
  end

  def full_month_factors(start_month, end_month)
    return 0 if start_month + 1 > end_month - 1
    (start_month + 1 .. end_month - 1).sum { |m| get_profile(m, 'month')}
  end

  def get_profile(month, period)
    Profile
      .where("profiles.month = ? AND profiles.period = ?", month, period)
      .pluck(:profile)
      .first
  end
end

class DayFactor
  attr_reader :bill_day, :month_end_day, :month_start_day, :end_date

  def initialize(date, factor_type, end_date)
    year = Date.parse(date).year
    month = Date.parse(date).month
    @month_end_day = Date.new(year, month, -1)
    @month_start_day = Date.new(year, month, 1)
    @bill_day = Date.parse(date)
    @end_date = Date.parse(end_date)
    @factor_type = factor_type
  end

  def wkend_factor
    @factor_type.bill_wkend_days(self).to_f / month_wkend_days.to_f
  end

  def wkday_factor
    @factor_type.bill_wkday_days(self).to_f / month_wkday_days.to_f
  end

  def month_wkend_days
    FindWkendDay.call(@month_start_day, @month_end_day)
  end

  def month_wkday_days
    @month_end_day.day - month_wkend_days
  end
end

class StartMonthFactor
  def bill_wkend_days(context)
    FindWkendDay.call(context.bill_day, context.month_end_day)
  end

  def bill_wkday_days(context)
    context.month_end_day.day - context.bill_day.day + 1 - bill_wkend_days(context)
  end
end

class EndMonthFactor
  def bill_wkend_days(context)
    FindWkendDay.call(context.month_start_day, context.bill_day)
  end

  def bill_wkday_days(context)
    context.bill_day.day - bill_wkend_days(context)
  end
end

class MonthFactor
  def bill_wkend_days(context)
    FindWkendDay.call(context.bill_day, context.end_date)
  end

  def bill_wkday_days(context)
    context.end_date.day - context.bill_day.day + 1 - bill_wkend_days(context)
  end
end

class FindWkendDay
  def self.call(d1, d2)
    wkdays = [1,2,3,4,5] #week days by numbers on week
    (d1..d2).reject { |d| wkdays.include?(d.wday) }.count #Day.wday number day in week
  end
end
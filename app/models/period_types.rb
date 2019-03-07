module PeriodTypes
  def self.list
    periods = (1..50).map { |n| n.to_s } << %w[ wkday_night wkday_day wkend_night wkend_day]
    periods.flatten
  end
end
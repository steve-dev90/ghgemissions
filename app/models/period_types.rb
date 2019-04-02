module PeriodTypes
  def self.list
    periods = (1..50).map { |n| n.to_s } << %w[ wkday wkend ]
    periods.flatten
  end
end


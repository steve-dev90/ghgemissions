class HalfHourlyEmission < ApplicationRecord

  def self.period_types()
    periods = (1..50).map { |n| n.to_s } << %w[ wkday_night wkday_day wkend_night wkend_day]
    periods.flatten
  end

  validates :month,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :period,
            presence: true,
            inclusion: { in: self.period_types }
  validates :trader,
            presence: true,
            format: { with: /[A-Z]{4}/, message: 'must be a valid trader id' }
  validates :emissions, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
  validates :emissions_factor, presence: true, numericality: true
end

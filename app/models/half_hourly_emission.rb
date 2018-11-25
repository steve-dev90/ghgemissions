class HalfHourlyEmission < ApplicationRecord
  validates :date, presence: true
  validates :trading_period,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :trader,
            presence: true,
            format: { with: /[A-Z]{4}/, message: 'must be a valid trader id' }
  validates :emissions, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
end

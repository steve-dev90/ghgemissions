class AutomotiveFuelPrice < ApplicationRecord
  FUEL_NAMES = %w[diesel regular_petrol premium_petrol].freeze

  validates :month,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

  validates :fuel_type,
            presence: true,
            inclusion: { in: FUEL_NAMES, message: '%{value} is not a valid fuel name' }

  validates :fuel_price,
            numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 300.0 },
            allow_nil: true
end

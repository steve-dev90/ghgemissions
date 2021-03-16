class CoalEmissionAdjustment < ApplicationRecord
  validates :month,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :adjust_factor,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 }
end

class Profile < ApplicationRecord
  include PeriodTypes

  validates :period,
            presence: true,
            inclusion: { in: PeriodTypes.list << 'month' }
  validates :month,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :profile,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 }
end

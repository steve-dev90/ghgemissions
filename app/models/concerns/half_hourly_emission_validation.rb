# See https://stackoverflow.com/questions/23506242/rails-apply-same-validation-to-same-attribute-in-different-models
module HalfHourlyEmissionValidation
  extend ActiveSupport::Concern

  included do
    include PeriodTypes

    validates :month,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
    validates :period,
              presence: true,
              inclusion: { in: (1..50).map { |n| n.to_s } }
    validates :trader,
              presence: true,
              format: { with: /[A-Z]{4}/, message: 'must be a valid trader id' }
    validates :emissions, presence: true, numericality: true
    validates :energy, presence: true, numericality: true
    validates :emissions_factor, presence: true, numericality: true
  end
end
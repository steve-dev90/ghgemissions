# See https://stackoverflow.com/questions/23506242/rails-apply-same-validation-to-same-attribute-in-different-models
module HalfHourlyEmissionValidation
  extend ActiveSupport::Concern

  included do
    include PeriodTypes
    #Same fuel types as generation_station model
    FUEL_NAMES = %w[geothermal coal natural_gas diesel hydro wood_waste wind process_waste].freeze

    validates :month,
              presence: true,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
    validates :period,
              presence: true,
              inclusion: { in: (1..50).map { |n| n.to_s } }
    validates :fuel_type,
              presence: true,
              inclusion: { in: FUEL_NAMES, message: '%{value} is not a valid fuel name' }
    validates :emissions, presence: true, numericality: true
    validates :energy, presence: true, numericality: true
    validates :emissions_factor, presence: true, numericality: true
  end
end
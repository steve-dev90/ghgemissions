class GenerationStation < ApplicationRecord
  FUEL_NAMES = %w[Geothermal Wood_waste Coal_NI Gas Diesel Biogas].freeze

  validates :station_name, presence: true
  validates :poc,
            presence: true,
            format: { with: /[A-Z]{3}\d{4}\s[A-Z]{3}\d{1,2}\z/, message: 'must be a valid point of connection' }
  validates :generation_type, presence: true
  validates :fuel_name,
            presence: true,
            inclusion: { in: FUEL_NAMES, message: '%{value} is not a valid fuel name' }
  validates :generation_type, presence: true
  validates :primary_efficiency, presence: true, numericality: true
  validates :emissions_factor,
            numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 },
            allow_nil: true
end

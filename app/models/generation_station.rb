class GenerationStation < ApplicationRecord
  FUEL_NAMES = %w[Geothermal Wood_waste Coal_NI Gas Diesel Biogas].freeze
  
  has_many :cleared_offers

  validates :station_name, presence: true
  validates :poc, presence: true, format: { with: /[A-Z]{3}\d{4}/,
    message: 'must be a valid point of connection' }
  validates :generation_type, presence: true
  validates :fuel_name, presence: true
  validates :primary_efficiency, presence: true, numericality: true
  validates :emissions_factor, presence: true, 
    numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 },
    allow_nil: true
end

class GenerationStation < ApplicationRecord
  FUEL_NAMES = %w[].freeze
  
  has_many :cleared_offers

  validates :station_name, presence: true
  validates :poc, presence: true, format: { with: /\[A-Z]{3}\d{4}/,
    message: 'must be a valid point of connection' }
  validates :generation_type, presence: true
  validates :fuel_name, presence: true
  validates :primary_efficiency, presence: true
end

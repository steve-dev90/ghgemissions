class GenerationStation < ApplicationRecord
  has_many :cleared_offers

  validates :station_name, presence: true
  validates :poc, presence: true, format: { with: /\D{3}\d{4}/,
    message: "must be a valid point of connection" }
  validates :generation_type, presence: true
  validates :fuel_name, presence: true
end

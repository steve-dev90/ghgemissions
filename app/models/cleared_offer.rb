class ClearedOffer < ApplicationRecord
  ISLANDS = %w[NI SI].freeze

  belongs_to :generation_station

  validates :date, presence: true
  validates :island, presence: true, inclusion: { in: ISLANDS,
    message: "%{value} is not a valid Island" }
  validates :poc, presence: true, format: { with: /[A-Z]{3}\d{4}\s[A-Z]{3}\d{1}/,
    message: 'must be a valid point of connection' }
  validates :trader, presence: true, format: { with: /[A-Z]{4}/,
    message: 'must be a valid point of connection' }
  validates :offer_type, presence: true, format: { with: /[A-Z]{4}/, 
    message: 'must be a valid point of connection' }
  validates :cleared_energy, presence: true, numericality: true
  validates :emissions, presence: true, numericality: true
end

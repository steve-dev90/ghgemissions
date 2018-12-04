class ClearedOffer < ApplicationRecord
  ISLANDS = %w[NI SI].freeze

  validates :date, presence: true
  validates :trading_period,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 48 }
  validates :island,
            presence: true,
            inclusion: { in: ISLANDS, message: '%{value} is not a valid Island' }
  validates :poc,
            presence: true,
            format: { with: /[A-Z]{3}\d{4}\s[A-Z]{3}\d{1,2}\z/, message: 'must be a valid point of connection' }
  validates :trader,
            presence: true,
            format: { with: /[A-Z]{4}/, message: 'must be a valid point of connection' }
  validates :offer_type,
            presence: true,
            format: { with: /[A-Z]{4}/, message: 'must be a valid point of connection' }
  validates :cleared_energy, presence: true, numericality: true
  validates :emissions, presence: true, numericality: true
end

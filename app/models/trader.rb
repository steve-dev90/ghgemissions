class Trader < ApplicationRecord
  validates :code,
            presence: true,
            format: { with: /[A-Z]{4}/, message: 'must be a valid point of trader' }
  validates :name, presence: true
end

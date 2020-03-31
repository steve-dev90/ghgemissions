class EnergyType < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true
end
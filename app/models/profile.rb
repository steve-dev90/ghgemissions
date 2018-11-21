class Profile < ApplicationRecord
  validates :trading_period, presence: true, numericality: { only_integer: true }
  validates :profile, presence: true, numericality: true
end

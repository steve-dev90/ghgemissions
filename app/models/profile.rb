class Profile < ApplicationRecord
  validates :trading_period, presence: true, 
    numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 48 }
  validates :profile, presence: true, numericality: true
end

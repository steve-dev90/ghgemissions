class EmissionFactor < ApplicationRecord
  FUEL_NAMES = %w[diesel reg_petrol prem_petrol natural_gas coal].freeze
  UNIT_NAMES = %w[kgCO2/litre kgCO2/kWh tCO2/TJ]

  validates :fuel_type,
            presence: true,
            inclusion: { in: FUEL_NAMES, message: '%{value} is not a valid fuel name' }

  validates :units,
            presence: true,
            inclusion: { in: UNIT_NAMES, message: '%{value} is not a valid unit name' }

  validates :factor,
            presence: true,
            numericality: true
end

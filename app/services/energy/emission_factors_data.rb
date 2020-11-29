#Run at set up to add energy types to db
#This should be refactored as a strategy not very DRY
class Energy::EmissionFactorsData
  # From MFE, Summary of Emissions Factors for the Guidance for Voluntary
  # Corporate Greenhouse Gas Reporting - 2015
  EMISSION_FACTORS = [
    {fuel_type: 'reg_petrol', units: 'kgCO2/litre', factor: 2.36 },
    {fuel_type: 'diesel', units: 'kgCO2/litre', factor: 2.36 },
    {fuel_type: 'prem_petrol', units: 'kgCO2/litre', factor: 2.72 }
  ].freeze

  def call
    save_records
    puts 'EmissionFactors table updated!'
  end

  def save_records
    EMISSION_FACTORS.each do |record|
      energy_type = EmissionFactor.find_or_create_by(fuel_type: record[:fuel_type], units: record[:unit])
      pp '*** Record not Valid ***', record, energy_type.errors.messages unless energy_type.update(record)
    end
  end
end
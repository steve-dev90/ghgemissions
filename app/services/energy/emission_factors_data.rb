#Run at set up to add energy types to db
#This should be refactored as a strategy not very DRY
class Energy::EmissionFactorsData
  # From MFE, Summary of Emissions Factors for the Guidance for Voluntary
  # Corporate Greenhouse Gas Reporting - 2015
  # Also https://www.mfe.govt.nz/sites/default/files/media/Climate%20Change/Measuring%20Emissions%20Detailed%20Guide%202020.pdf
  # Also New Zealand Greenhouse Gas Inventory 1990 2016, Page 459.
  EMISSION_FACTORS = [
    {fuel_type: 'reg_petrol', units: 'kgCO2/litre', factor: 2.36 },
    {fuel_type: 'diesel', units: 'kgCO2/litre', factor: 2.36 },
    {fuel_type: 'prem_petrol', units: 'kgCO2/litre', factor: 2.72 },
    {fuel_type: 'natural_gas', units: 'kgCO2/kWh', factor: 0.195},
    {fuel_type: 'natural_gas', units: 'tCO2/TJ', factor: 53.96},
    {fuel_type: 'coal', units: 'tCO2/TJ', factor: 92.2},
    {fuel_type: 'diesel', units: 'tCO2/TJ', factor: 69.69}
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
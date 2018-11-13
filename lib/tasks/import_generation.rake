require 'roo'

desc "Import EA existing generation spreadsheet"
task :import_ea_exist_generation => :environment do 
  exist_generation = ImportExistGeneration.new('./lib/assets/20151030_Existing_generating_plant.xlsx')
  exist_generation.call 
end

class ImportExistGeneration
  # New Zealand’s Greenhouse Gas Inventory 1990–2016, Page 459. 
  # Units tCO2/TJ
  # CHECK DIESEL!!!
  FOSSIL_FUEL_EMISSIONS_FACTORS = { 'Gas' => 53.96, 'Coal_NI' => 92.2, 'Diesel' => 50}
  # http://nzgeothermal.org.nz/emissions/
  # Units tCO2/MWh
  GEOTHERMAIL_ELECTRICITY_EMISSIONS_FACTOR = 0.100
  GAS_POWER_STATION_EFFICIENCY_ESTIMATE = 9000
  # This needs some work
  DIESEL_POWER_STATION_EFFICIENCY_ESTIMATE = 9000
  
  def initialize(file)
    @file = file
  end  
  
  def call
    read_file
  end

  def read_file
    Roo::Spreadsheet.open(@file).sheet("Generating Stations").each do |row| 
      next if row[0] == 'Station_Name'
      hash = {}
      hash = {
        station_name: row[0],
        poc: row[20],
        generation_type: row[5],
        fuel_name: row[7],
        primary_efficiency: row[8] }
      hash[:emissions_factor] = get_emissions_factor(hash[:fuel_name],
        hash[:primary_efficiency], hash[:generation_type])  
      GenerationStation.create(hash)   
    end 
  end  
  
  def get_emissions_factor(fuel_name, primary_efficiency, generation_type)
    return unless ['Gas', 'Coal_NI', 'Diesel', 'Geothermal'].include?(fuel_name)
    return GEOTHERMAIL_ELECTRICITY_EMISSIONS_FACTOR if fuel_name == 'Geothermal'    
    if primary_efficiency.zero?
      if fuel_name == 'Gas' && generation_type == 'Thermal' 
        GAS_POWER_STATION_EFFICIENCY_ESTIMATE * FOSSIL_FUEL_EMISSIONS_FACTORS[fuel_name] / 10**6
      elsif fuel_name == 'Diesel'
        DIESEL_POWER_STATION_EFFICIENCY_ESTIMATE * FOSSIL_FUEL_EMISSIONS_FACTORS[fuel_name] / 10**6   
      end 
    else  
      primary_efficiency * FOSSIL_FUEL_EMISSIONS_FACTORS[fuel_name] / 10**6 
    end  
  end  
end 
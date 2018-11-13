require 'roo'

desc "Import EA existing generation spreadsheet"
task :import_ea_exist_generation => :environment do 
  exist_generation = ImportExistGeneration.new('./lib/assets/20151030_Existing_generating_plant.xlsx')
  exist_generation.call 
end

class ImportExistGeneration
  # New Zealand Greenhouse Gas Inventory 1990 2016, Page 459. 
  # Units tCO2/TJ
  # CHECK DIESEL!!!
  FOSSIL_FUEL_EMISSIONS_FACTORS = { 'Gas' => 53.96, 'Coal_NI' => 92.2, 'Diesel' => 50.0 }.freeze
  # http://nzgeothermal.org.nz/emissions/
  # Units tCO2/MWh
  GEOTHERMAL_ELECTRICITY_EMISSIONS_FACTOR = 0.100
  # This needs some work
  HEAT_RATE_ESTIMATES = { 'Gas' => 9000, 'Diesel' => 9000 }.freeze
  
  def initialize(file)
    @file = file
  end  
  
  def call
    Roo::Spreadsheet.open(@file).sheet("Generating Stations").each do |row| 
      next if row[0] == 'Station_Name'      
      record = get_record(row)
      record[:primary_efficiency] = get_primary_efficiency(
        record[:primary_efficiency],
        record[:fuel_name],
        record[:generation_type]
      )  
      record[:emissions_factor] = get_emissions_factor(
        record[:fuel_name],
        record[:primary_efficiency]
      )  
      save_record(record)   
    end 
  end
  
  def get_record(row)
    { station_name: row[0],
      poc: row[20],
      generation_type: row[5],
      fuel_name: row[7] }
  end  
  
  def get_primary_efficiency(efficiency, fuel_name, generation_type) 
    return estimate_primary_efficiency(fuel_name, generation_type) if efficiency.nil?    
    return efficiency unless efficiency.zero?
    estimate_primary_efficiency(fuel_name, generation_type)     
  end

  def estimate_primary_efficiency(fuel_name, generation_type)
    if fuel_name == 'Gas' && generation_type == 'Thermal' 
      HEAT_RATE_ESTIMATES[fuel_name]
    elsif fuel_name == 'Diesel'
      HEAT_RATE_ESTIMATES[fuel_name]
    else
      0.0  
    end
  end  

  def get_emissions_factor(fuel_name, primary_efficiency)
    case fuel_name
    when 'Gas', 'Coal_NI', 'Diesel' 
      primary_efficiency * FOSSIL_FUEL_EMISSIONS_FACTORS[fuel_name] / 10**6
    when 'Geothermal'
      GEOTHERMAL_ELECTRICITY_EMISSIONS_FACTOR
    end  
  end

  def save_record(record)
    generation_station = GenerationStation.find_or_create_by(
      station_name: record[:station_name],
      poc: record[:poc]
    )
    generation_station.update_attributes(record)
  end  
end 
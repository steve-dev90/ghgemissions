require 'roo'

desc "Import EA existing generation spreadsheet"
task :import_ea_exist_generation => :environment do 
  exist_generation = ImportExistGeneration.new('./lib/assets/20151030_Existing_generating_plant.xlsx')
  exist_generation.call 
end

class ImportExistGeneration
  
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
      pp hash   
    end 
  end      
end 
require 'csv'

desc "Import EA cleared offers csv"
task :import_ea_cleared_offers => :environment do 
  cleared_offers = ImportClearedOffers.new('./lib/assets/20181103_Cleared_Offers.csv')
  cleared_offers.call 
end

class ImportClearedOffers
  
  def initialize(file)
    @file = file
  end 
 
  def call
    CSV.foreach(@file) do |row|
      next if row[0] == 'Date' || row[5] != 'ENOF'
      record = get_record(row)
      record[:power_station_id] = get_power_station_id(record[:poc])
      record[:emissions] = get_emissions
      save_record(record) 
      ClearedOffer.create(hash)  
    end 
  end
  
  def get_record(row)
    { date: row[0],
      trading_period: row[1],
      island: row[2],
      poc: row[3],
      trader: row[4],
      offer_type: row[5],
      cleared_energy: row[6] }
  end 
  
  def get_power_station_id(poc)
    GenerationStation.find_by(poc: poc.split[0]).id
  end

  def get_emissions(cleared_energy, power_station_id)
    return 0.0 if power_station_id.nil?
    generation_station = GenerationStation.where(id: power_station_id) 
    # WORKING HERE
    if generation_station
      0.0
    else  
      cleared_energy * (generation_station.first[:emissions_factor] || 0)
    end  
  end  
  
  def save_record(record)
    cleared_offer = ClearedOffer.find_or_create_by(
      date: record[:date],
      trading_period: record[:trading_period],
      island: record[:island_date],
      poc: record[:poc],
      trader: record[:trader],
      offer_type: record[:offer_type]
    )
    cleared_offer.update_attributes(record)
  end  
end 

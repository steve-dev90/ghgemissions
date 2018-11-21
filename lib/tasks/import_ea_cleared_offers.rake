require 'csv'

desc 'Import EA cleared offers csv'
task import_ea_cleared_offers: :environment do
  cleared_offers = ImportClearedOffers.new('./lib/assets/20181103_Cleared_Offers.csv')
  cleared_offers.call
end

class ImportClearedOffers
  def initialize(file)
    @file = file
  end

  def call
    ClearedOffer.destroy_all
    CSV.foreach(@file) do |row|
      next if row[0] == 'Date' || row[5] != 'ENOF'

      record = get_record(row)
      record[:generation_station_id] = get_generation_station_id(record[:poc])
      record[:emissions] = get_emissions(record[:cleared_energy], record[:generation_station_id])
      save_record(record)     
    end
  end

  def get_record(row)
    { date: row[0],
      trading_period: row[1],
      island: row[2],
      poc: row[3],
      trader: row[4],
      offer_type: row[5],
      cleared_energy: row[6].to_f }
  end

  def get_generation_station_id(poc)
    GenerationStation.find_by(poc: poc.split[0])&.id
  end

  def get_emissions(cleared_energy, generation_station_id)
    return 0.0 if generation_station_id.nil?

    emissions_factor = GenerationStation.where(id: generation_station_id).first[:emissions_factor]
    (cleared_energy.to_f * 0.5 * (emissions_factor || 0)).round(2)
  end

  def save_record(record)
    cleared_offer = ClearedOffer.new(record)  
    pp '*** Record not Valid ***', record, cleared_offer.errors.messages unless cleared_offer.save  
  end  
end

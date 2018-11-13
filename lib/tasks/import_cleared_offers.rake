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
    read_file
  end

  def read_file
    CSV.foreach(@file) do |row|
      next if row[0] == 'Date'
      hash = {}
      hash = {
        date: row[0],
        trading_period: row[1],
        island: row[2],
        poc: row[3],
        trader: row[4],
        offer_type: row[5],
        cleared_energy: row[6] }
      ClearedOffer.create(hash)  
    end 
  end   
end 

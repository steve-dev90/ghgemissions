require 'csv'

desc "Import EA cleared offers csv"
task :import_ea_cleared_offers => :environment do 
  cleared_offers = ImportClearedOffers.new('./lib/assets/20181103_Cleared_Offers.csv')
  cleared_offers.call 
end

class ImportClearedOffers
  
  def initialize(file)
    @file = file
    @cleared_offer_rows = [] 
  end  
  
  def call
    read_file
    pp @cleared_offer_rows
    # self.validate_records
    # self.save_to_database
  end

  def read_file
    # Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)
    CSV.foreach(@file) do |row|
      hash = {}
      hash = {
        date: row[0],
        trading_period: row[1],
        island: row[2],
        poc: row[3],
        trader: row[4],
        offer_type: row[5],
        cleared_energy: row[6] }
      @cleared_offer_rows << hash  

    end 
  end   
end 

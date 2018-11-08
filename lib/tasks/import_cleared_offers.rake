desc "Import EA cleared offers csv"
task :import_ea_cleared_offers => :environment do 
  ImportClearedOffers.call('20181103_Cleared_Offers.csv')
end

class ImportClearedOffers
  
  def self.call(file)
    # self.read_file
    # self.validate_records
    # self.save_to_database
  end


end  

 

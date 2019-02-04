namespace :power do
  desc 'Import EA cleared offers csv'
  task import_ea_cleared_offers: :environment do
    cleared_offers = Power::ClearedOfferData.new('./lib/assets/20181103_Cleared_Offers.csv')
    cleared_offers.call
  end
end

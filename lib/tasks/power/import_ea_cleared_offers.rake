namespace :power do
  desc 'Import EA cleared offers csv'
  task import_ea_cleared_offers: :environment do
    cleared_offers = Power::ClearedOfferData.new('./lib/assets/cleared_offer_data/*')
    cleared_offers.call
  end
end

namespace :power do
  desc 'Import cleared offers from the emi website'
  task emi_cleared_data_daily_import: :environment do
    process_emi_folder = Power::ClearedOfferDataEMI.new("./lib/assets/cleared_offer_data_emi_prod/")
    process_emi_folder.call
  end
end
namespace :power do
  desc 'Import trader data'
  task import_trader_data: :environment do
    trader = Power::TraderData.new
    trader.call
  end
end

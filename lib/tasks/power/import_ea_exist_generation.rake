require 'roo'

namespace :power do
  desc 'Import EA existing generation spreadsheet'
  task import_ea_exist_generation: :environment do
    exist_generation = Power::GenerationData.new('./lib/assets/20151030_Existing_generating_plant.xlsx')
    exist_generation.call
  end
end
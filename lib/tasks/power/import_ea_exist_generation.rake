namespace :power do
  desc 'Import EA existing generation spreadsheet'
  task import_ea_exist_generation: :environment do
    exist_generation = Power::GenerationData.new(
      './lib/assets/202101_existing_generating_plant.xlsx',
      'Generating Stations')
    exist_generation.call
  end
end

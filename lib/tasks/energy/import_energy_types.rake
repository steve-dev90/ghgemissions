namespace :energy do
  desc 'Import energy types'
  task import_energy_types: :environment do
    energy_types = Energy::EnergyTypesData.new
    energy_types.call
  end
end
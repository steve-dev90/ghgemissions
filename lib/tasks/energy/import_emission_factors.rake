namespace :energy do
  desc 'Import emission factors'
  task import_emission_factors: :environment do
    emissions = Energy::EmissionFactorsData.new
    emissions.call
  end
end
namespace :power do
  desc 'Create daily emissions factor'
  task create_half_hourly_emissions_factors: :environment do
    hh_emissions = Power::EmissionsData.new
    hh_emissions.call
  end
end  
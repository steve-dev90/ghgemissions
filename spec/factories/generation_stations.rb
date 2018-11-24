FactoryBot.define do
  factory :generation_station do
    station_name { 'Huntly' }
    poc { 'HLY2201' }
    fuel_name { 'Gas' }
    generation_type { 'Thermal' }
    primary_efficiency { 9000 }
    emissions_factor { 0.48 }
  end
end
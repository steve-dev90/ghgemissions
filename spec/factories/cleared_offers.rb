FactoryBot.define do
  factory :cleared_offer do
    date { '2018-11-03' }
    trading_period { 1 }
    island { 'NI' }
    poc { 'GLN0332 GLN0' }
    trader { 'ALNT' }
    offer_type { 'ENOF' }
    cleared_energy { 50.0 }
    emissions { 4.15 }
    generation_station_id { 1 }
  end
end

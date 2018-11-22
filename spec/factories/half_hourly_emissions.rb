FactoryBot.define do
  factory :half_hourly_emission do
    date { '19/10/18' }
    trading_period { 1 }
    trader { 'CTCT' }
    emissions { 150.0 }
    energy { 1.5 }
    emissions_factor { 0.002 }
  end
end

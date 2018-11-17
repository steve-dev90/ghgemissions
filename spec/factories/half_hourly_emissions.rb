FactoryBot.define do
  factory :half_hourly_emission do
    date { 'MyString' }
    trading_period { 1 }
    trader { 'MyString' }
    emissions { 1.5 }
    energy { 1.5 }
    emissions_factor { 1.5 }
  end
end

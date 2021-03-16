FactoryBot.define do
  factory :automotive_fuel_price do
    month_beginning { "2016-01-01" }
    fuel_type { "diesel" }
    fuel_price { "90.99" }
  end
end
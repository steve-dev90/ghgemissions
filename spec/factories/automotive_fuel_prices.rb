FactoryBot.define do
  factory :automotive_fuel_price do
    week_ending { "2020-08-02" }
    fuel_type { "MyString" }
    fuel_price { "9.99" }
  end
end

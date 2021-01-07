FactoryBot.define do
  factory :emission_factor do
    fuel_type { 'reg_petrol' }
    units { 'kgCO2/litre' }
    factor { 3.0 }
  end
end

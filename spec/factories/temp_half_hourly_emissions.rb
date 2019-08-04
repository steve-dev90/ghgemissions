FactoryBot.define do
  factory :temp_half_hourly_emission do
    month { '1' }
    period { '1' }
    trader { 'CTCT' }
    emissions { 150.0 }
    energy { 1.5 }
    emissions_factor { 0.001 }
  end
end

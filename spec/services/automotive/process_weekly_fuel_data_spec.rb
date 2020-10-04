require 'rails_helper'

RSpec.describe Automotive::ProcessWeeklyFuelData do

  it 'processes three records ' do
    file = './spec/services/automotive/weekly-table-test-1.csv'
    data = CSV.read(file, converters: :numeric, headers:true)
    weekly_fuel_data = Automotive::ProcessWeeklyFuelData.new(data)
    weekly_fuel_data.call
    expect(AutomotiveFuelPrice.order(:month_beginning).first[:month_beginning]).to eq(Date.new(2020,3,1))
    expect(AutomotiveFuelPrice.all.count).to eq(9)
    expect(AutomotiveFuelPrice.where(fuel_type: "regular_petrol").sum("fuel_price")).to eq(600.0)
    expect(AutomotiveFuelPrice.where(fuel_type: "diesel").sum("fuel_price")).to eq(300.0)
    expect(AutomotiveFuelPrice.where(fuel_type: "premium_petrol").sum("fuel_price")).to eq(600.0 * 1.06)
  end

  it 'processes nine records - excluding earlier date' do
    file = './spec/services/automotive/weekly-table-test-2.csv'
    data = CSV.read(file, converters: :numeric, headers:true)
    weekly_fuel_data = Automotive::ProcessWeeklyFuelData.new(data)
    weekly_fuel_data.call
    expect(AutomotiveFuelPrice.order(:month_beginning).first[:month_beginning]).to eq(Date.new(2020,3,1))
    expect(AutomotiveFuelPrice.all.count).to eq(9)
    expect(AutomotiveFuelPrice.where(fuel_type: "regular_petrol").sum("fuel_price")).to eq(600.0)
    expect(AutomotiveFuelPrice.where(fuel_type: "diesel").sum("fuel_price")).to eq(300.0)
    expect(AutomotiveFuelPrice.where(fuel_type: "premium_petrol").sum("fuel_price")).to eq(600.0 * 1.06)
  end

end

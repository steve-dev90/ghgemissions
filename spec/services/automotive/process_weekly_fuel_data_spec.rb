require 'rails_helper'

RSpec.describe Automotive::ProcessWeeklyFuelData do
  before(:all) do
    file = './spec/services/automotive/weekly-table-test.csv'
    @data = CSV.read(file, converters: :numeric, headers:true)
  end

  it 'processes a file' do
    weekly_fuel_data = Automotive::ProcessWeeklyFuelData.new(@data)
    weekly_fuel_data.call
  end

end

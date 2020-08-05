require 'rails_helper'

RSpec.describe Automotive::ProcessWeeklyFuelData do
  before(:all) do
    # Nothing
  end

  it 'processes a file' do
    file = './spec/services/automotive/weekly-table-test.csv'
    weekly_fuel_data = Automotive::ProcessWeeklyFuelData.new(file)
    weekly_fuel_data.call
  end

 end

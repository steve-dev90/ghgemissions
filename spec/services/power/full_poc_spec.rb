require 'rails_helper'

RSpec.describe Power::GenerationData do
  before(:all) do
    pocs = Power::FullPoc.new('./spec/services/power/existing_generating_plant_test.xlsx')
    @poc_list = pocs.call
  end

  it 'reads the correct number of pocs' do
    expect(@poc_list.size).to eq(21)
  end

  it 'ignores power plants without a full poc' do
    expect(@poc_list.map{ |p| p[:full_poc]}).to_not include('', nil)
  end
end
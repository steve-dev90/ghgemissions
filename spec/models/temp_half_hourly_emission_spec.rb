require 'rails_helper'

RSpec.describe TempHalfHourlyEmission, type: :model do
  before(:all) do
    @thhemission1 = FactoryBot.create(:temp_half_hourly_emission)
    pp @thhemission1
  end

  it 'is valid with valid attributes' do
    expect(@thhemission1).to be_valid
  end

end

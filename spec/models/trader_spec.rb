require 'rails_helper'

RSpec.describe Trader, type: :model do
  before(:all) do
    @trader1 = FactoryBot.create(:trader)
  end

  it 'is valid with valid attributes' do
    expect(@trader1).to be_valid
  end

  it 'invalidates records with no code' do
    trader2 = FactoryBot.build(:trader, code: nil)
    expect(trader2).to_not be_valid
  end

  it 'invalidates records with no name' do
    trader2 = FactoryBot.build(:trader, name: nil)
    expect(trader2).to_not be_valid
  end

  it 'invalidates records with an invalid trader ID' do
    trader2 = FactoryBot.build(:trader, code: 'Genesis')
    expect(trader2).to_not be_valid
  end
end

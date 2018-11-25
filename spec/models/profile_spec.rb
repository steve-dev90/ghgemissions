require 'rails_helper'

RSpec.describe Profile, type: :model do
  before(:all) do
    @profile1 = FactoryBot.create(:profile)
  end

  it 'is valid with valid attributes' do
    expect(@profile1).to be_valid
  end

  it 'invalidates records with no trading period' do
    profile2 = FactoryBot.build(:profile, trading_period: nil)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with non integer trading periods' do
    profile2 = FactoryBot.build(:profile, trading_period: 'a')
    # pp station.valid?
    # pp station.errors.messages
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with trading periods less than 1' do
    profile2 = FactoryBot.build(:profile, trading_period: 0)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with trading periods greater than 50' do
    profile2 = FactoryBot.build(:profile, trading_period: 51)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with no profile' do
    profile2 = FactoryBot.build(:profile, profile: nil)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a profile that is not a float' do
    profile2 = FactoryBot.build(:profile, profile: 'a')
    # pp station.valid?
    # pp station.errors.messages
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a profile less than 0' do
    profile2 = FactoryBot.build(:profile, profile: -0.1)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a profile greater than 0.4' do
    profile2 = FactoryBot.build(:profile, profile: 0.41)
    expect(profile2).to_not be_valid
  end
end

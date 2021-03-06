require 'rails_helper'

RSpec.describe Profile, type: :model do
  before(:all) do
    # Energy types must be defined for profile validation to work
    EnergyType.destroy_all
    FactoryBot.create(:energy_type)
    FactoryBot.create(:energy_type, name: 'gas', id: 2)
    @profile1 = FactoryBot.build(:profile)
  end

  it 'is valid with valid attributes' do
    EnergyType.pluck(:id)
    expect(@profile1).to be_valid
  end

  it 'invalidates records with no period' do
    profile2 = FactoryBot.build(:profile, period: nil)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with periods less than 1' do
    profile2 = FactoryBot.build(:profile, period: '0')
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with periods greater than 50' do
    profile2 = FactoryBot.build(:profile, period: '51')
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a non-valid period' do
    profile2 = FactoryBot.build(:profile, period: 'weekend')
    expect(profile2).to_not be_valid
  end

  it 'validates records with a month period' do
    profile2 = FactoryBot.build(:profile, period: 'month')
    expect(profile2).to be_valid
  end

  it 'invalidates records with no month' do
    profile2 = FactoryBot.build(:profile, month: nil)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with non integer months' do
    profile2 = FactoryBot.build(:profile, month: 'Jan')
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a month less than 1' do
    profile2 = FactoryBot.build(:profile, month: 0)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a month greater than 12' do
    profile2 = FactoryBot.build(:profile, month: 14)
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

  it 'invalidates records with a profile greater than 1.0' do
    profile2 = FactoryBot.build(:profile, profile: 1.01)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a no energy_type' do
    profile2 = FactoryBot.build(:profile, energy_type: nil)
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a non-integer energy_type' do
    profile2 = FactoryBot.build(:profile, energy_type: 'one')
    expect(profile2).to_not be_valid
  end

  it 'invalidates records with a energy_type that is not a 1 or 2' do
    profile2 = FactoryBot.build(:profile, energy_type: 3)
    expect(profile2).to_not be_valid
  end

end

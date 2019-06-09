require 'rails_helper'

RSpec.describe Power::PreviousMonthEnergyEstimate do
  before(:all) do
    @energy_estimate = Power::PreviousMonthEnergyEstimate.new(
      100,
      '15/04/2019',
      '17/05/2019'
    )
    Profile.destroy_all
    FactoryBot.create(:profile, period: 'month', month: 4, profile: 0.094610524)
    FactoryBot.create(:profile, period: 'wkend', month: 4, profile: 0.24123403)
    FactoryBot.create(:profile, period: 'wkday', month: 4, profile: 0.75876597)
    FactoryBot.create(:profile, period: 'month', month: 5, profile: 0.094610524)
    @energy_estimate.call
  end

  it 'calculates the correct energy for march' do

  end

end
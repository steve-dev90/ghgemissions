require 'rails_helper'

RSpec.describe Power::ProfileData do
  before(:all) do
    Profile.destroy_all
    @profile = Power::ProfileData.new('./spec/services/power/CPK0111 RPS test.xlsx')
    @profile.call
  end

  it 'uploads the correct number of records' do
    expect(Profile.count).to eq(3)
  end

  it 'calculates a normalised profile' do
    sum_tp1 = 100 * 30
    sum_tpall = 100.0 * 30.0 + 120.0 * 30.0 + 140.0 * 30.0
    expect(Profile.find_by(trading_period: 1)[:profile].round(4)).to eq((sum_tp1 / sum_tpall).round(4))
    expect(Profile.sum(:profile)).to eq(1.0)
  end
end

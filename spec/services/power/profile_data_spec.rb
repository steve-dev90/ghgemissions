require 'rails_helper'

RSpec.describe Power::ProfileData do
  before(:all) do
    Profile.destroy_all
    @profile = Power::ProfileData.new('./spec/services/power/CPK0111_RPS_Test.csv')
    @profile.call
  end

  it 'calculates normalised monthly, trading period, weekday and weekend profiles correctly' do
    #sum profile over all trading periods, trading dates for each month
    sum_monthly_profile = [0, 0, 0, 0, 0, 0, 0, 0, 90.0, 0, 0, 0]
    #sum profile over trading period 1, for all trading dates, for each month
    sum_tp1_profile = [0, 0, 0, 0, 0, 0, 0, 0, 8.0, 0, 0, 0]
    #sum profile over weekend night trading periods, for each month
    sum_wkend_night_profile = [0, 0, 0, 0, 0, 0, 0, 0, 20.0, 0, 0, 0]
    #sum profile over weekend day trading periods, for each month
    sum_wkend_day_profile = [0, 0, 0, 0, 0, 0, 0, 0, 25.0, 0, 0, 0]
    #sum profile over all trading periods, trading dates and months
    sum_wkday_night_profile = [0, 0, 0, 0, 0, 0, 0, 0, 20.0, 0, 0, 0]
    #sum profile over weekend day trading periods, for each month
    sum_wkday_day_profile = [0, 0, 0, 0, 0, 0, 0, 0, 25.0, 0, 0, 0]
    #sum profile over all trading periods, trading dates and months
    pp sum_profile = sum_monthly_profile.sum { |n| n }
    expect(Profile.find_by(period: 'month', month: '9')[:profile].round(4)).to eq((sum_monthly_profile[8] / sum_profile).round(4))
    expect(Profile.find_by(period: 'wkend_night', month: '9')[:profile].round(4)).to eq((sum_wkend_night_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.find_by(period: 'wkend_day', month: '9')[:profile].round(4)).to eq((sum_wkend_day_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.find_by(period: 'wkday_night', month: '9')[:profile].round(4)).to eq((sum_wkday_night_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.find_by(period: 'wkday_day', month: '9')[:profile].round(4)).to eq((sum_wkday_day_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.find_by(period: '1', month: '9')[:profile].round(4)).to eq((sum_tp1_profile[8] / sum_monthly_profile[8]).round(4))
  end
end

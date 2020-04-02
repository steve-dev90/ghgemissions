require 'rails_helper'

RSpec.describe Energy::ProfileData do
  before(:all) do
    FactoryBot.create(:energy_type)
    FactoryBot.create(:energy_type, id: 2, name: 'gas')
    Profile.destroy_all
  end

  it 'calculates normalised monthly, trading period, weekday and weekend profiles correctly - one month only, power' do
    skip
    @profile = Energy::ProfileData.new('./spec/services/energy/CPK0111_RPS_Test.csv', 'power', &POWER_TRADING_PERIOD_PROCESSOR)
    @profile.call
    #sum profile over all trading periods, trading dates for each month
    sum_monthly_profile = [0, 0, 0, 0, 0, 0, 0, 0, 90.0, 0, 0, 0]
    #sum profile over trading period 1, for all trading dates, for each month
    sum_tp1_profile = [0, 0, 0, 0, 0, 0, 0, 0, 8.0, 0, 0, 0]
    #sum profile over weekend trading periods, for each month
    sum_wkend_profile = [0, 0, 0, 0, 0, 0, 0, 0, 45.0, 0, 0, 0]
    #sum profile over weekend trading periods, for each month
    sum_wkday_profile = [0, 0, 0, 0, 0, 0, 0, 0, 45.0, 0, 0, 0]
    #sum profile over all trading periods, trading dates and months
    sum_profile = sum_monthly_profile.sum { |n| n }
    expect(Profile.find_by(period: 'month', month: '9', energy_type: energy_type)[:profile].round(4)).to eq((sum_monthly_profile[8] / sum_profile).round(4))
    expect(Profile.find_by(period: 'wkend', month: '9', energy_type: energy_type)[:profile].round(4)).to eq((sum_wkend_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.find_by(period: 'wkday', month: '9', energy_type: energy_type)[:profile].round(4)).to eq((sum_wkday_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.find_by(period: '1', month: '9', energy_type: energy_type)[:profile].round(4)).to eq((sum_tp1_profile[8] / sum_monthly_profile[8]).round(4))
    expect(Profile.where.not(period: ['month','wkday','wkend']).where(month: '9', energy_type: energy_type).sum(:profile)).to eq(1.0)
    expect(Profile.where(period: ['wkday','wkend']).where(month: '9', energy_type: energy_type).sum(:profile)).to eq(1.0)
  end

  it 'calculates normalised monthly, trading period, weekday and weekend profiles correctly - multiple months only' do
    skip
    #need to filter for energy type
    @profile = Energy::ProfileData.new('./spec/services/energy/CPK0111_RPS_Test_Months.csv', 'power', &POWER_TRADING_PERIOD_PROCESSOR)
    @profile.call
    #sum profile over all trading periods, trading dates for each month
    sum_monthly_profile = [12.0, 12.0, 12.0, 12.0, 0, 0, 0, 0, 0.0, 0, 0, 0]
    #sum profile over trading period 1, for all trading dates, for each month
    sum_tp1_profile = [4.0, 4.0, 4.0, 4.0, 0, 0, 0, 0, 0.0, 0, 0, 0]
    #sum profile over weekend trading periods, for each month
    sum_monthly_profile = [12.0, 12.0, 12.0, 12.0, 0, 0, 0, 0, 0.0, 0, 0, 0]
    #sum profile over weekend trading periods, for each month
    sum_wkday_profile = [0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0, 0, 0]
    #sum profile over all trading periods, trading dates and months
    sum_profile = sum_monthly_profile.sum { |n| n }
    expect(Profile.find_by(period: 'month', month: '1')[:profile].round(4)).to eq((sum_monthly_profile[0] / sum_profile).round(4))
    expect(Profile.find_by(period: 'month', month: '2')[:profile].round(4)).to eq((sum_monthly_profile[1] / sum_profile).round(4))
    expect(Profile.find_by(period: '1', month: '1')[:profile].round(4)).to eq((sum_tp1_profile[0] / sum_monthly_profile[0]).round(4))
    expect(Profile.where.not(period: ['month','wkday','wkend']).where(month: '1').sum(:profile)).to eq(1.0)
    expect(Profile.where(period: 'month').sum(:profile)).to eq(1.0)
  end

  it 'calculates normalised monthly, weekday and weekend profiles correctly - one month only, gas' do
    @profile = Energy::ProfileData.new('./spec/services/energy/BEL24510_Test_One_Month.txt', 'gas', &GAS_TRADING_PERIOD_PROCESSOR)
    @profile.call
    # #sum profile over all trading periods, trading dates for each month
    # sum_monthly_profile = [0, 0, 0, 0, 0, 0, 0, 0, 90.0, 0, 0, 0]
    # #sum profile over trading period 1, for all trading dates, for each month
    # sum_tp1_profile = [0, 0, 0, 0, 0, 0, 0, 0, 8.0, 0, 0, 0]
    # #sum profile over weekend trading periods, for each month
    # sum_wkend_profile = [0, 0, 0, 0, 0, 0, 0, 0, 45.0, 0, 0, 0]
    # #sum profile over weekend trading periods, for each month
    # sum_wkday_profile = [0, 0, 0, 0, 0, 0, 0, 0, 45.0, 0, 0, 0]
    # #sum profile over all trading periods, trading dates and months
    # sum_profile = sum_monthly_profile.sum { |n| n }
    # expect(Profile.find_by(period: 'month', month: '9')[:profile].round(4)).to eq((sum_monthly_profile[8] / sum_profile).round(4))
    # expect(Profile.find_by(period: 'wkend', month: '9')[:profile].round(4)).to eq((sum_wkend_profile[8] / sum_monthly_profile[8]).round(4))
    # expect(Profile.find_by(period: 'wkday', month: '9')[:profile].round(4)).to eq((sum_wkday_profile[8] / sum_monthly_profile[8]).round(4))
    # expect(Profile.find_by(period: '1', month: '9')[:profile].round(4)).to eq((sum_tp1_profile[8] / sum_monthly_profile[8]).round(4))
    # expect(Profile.where.not(period: ['month','wkday','wkend']).where(month: '9').sum(:profile)).to eq(1.0)
    # expect(Profile.where(period: ['wkday','wkend']).where(month: '9').sum(:profile)).to eq(1.0)
  end

end

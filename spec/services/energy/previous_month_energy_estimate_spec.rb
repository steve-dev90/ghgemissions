require 'rails_helper'

RSpec.describe Energy::PreviousMonthEnergyEstimate do

  before(:all) do
    FactoryBot.create(:energy_type)
    FactoryBot.create(:energy_type, name: 'gas', id: 2)
    # Need this next line all EnergyType doesn't save - weird
    EnergyType.pluck(:id)
  end

  context 'with power' do
    before(:all) do
      Profile.destroy_all
      (1..12).each do |month|
        FactoryBot.create(:profile, period: 'month', month: month, profile: 0.1)
        FactoryBot.create(:profile, period: 'wkend', month: month, profile: 0.3)
        FactoryBot.create(:profile, period: 'wkday', month: month, profile: 0.7)
      end
    end

    it 'estimates correctly if billing period covers one full month' do
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '1/04/2019',
        '30/04/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'power'
      )
      expect(@energy_estimate.call).to eq(100.0 * 0.1 / 0.1)
    end

    it 'estimates correctly if billing period covers a partial month' do
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '1/04/2019',
        '15/04/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'power'
      )
      month_factors = 0.1 * (0.7 * (11.0 / 22.0) + 0.3 * (4.0 / 8.0))
      expect(@energy_estimate.call).to eq(100.0 * 0.1 / month_factors)
    end

    it 'estimates correctly if billing period covers two partial months' do
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '15/04/2019',
        '17/05/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'power'
      )
      month_factors = 0.1 * (0.7 * (12.0 / 22.0) + 0.3 * (4.0 / 8.0)) +
        0.1 * (0.7 * (13.0 / 23.0) + 0.3 * (4.0 / 8.0))
      expect(@energy_estimate.call).to eq(100.0 * 0.1 / month_factors)
    end

    it 'estimates correctly if billing period covers two partial months and one full month' do
      # skip
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '15/04/2019',
        '15/06/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'power'
      )
      month_factors = 0.1 * (0.7 * (12.0 / 22.0) + 0.3 * (4.0 / 8.0)) +
        0.1 +
        0.1 * (0.7 * (10.0 / 20.0) + 0.3 * (5.0 / 10.0))
      expect(@energy_estimate.call).to eq(100.0 * 0.1 / month_factors)
    end

    it 'estimates correctly if billing period covers two partial months and two full month' do
      # skip
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '15/04/2019',
        '15/07/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'power'
      )
      month_factors = 0.1 * (0.7 * (12.0 / 22.0) + 0.3 * (4.0 / 8.0)) +
        0.2 +
        0.1 * (0.7 * (11.0 / 23.0) + 0.3 * (4.0 / 8.0))
      expect(@energy_estimate.call).to be_within(0.0001).of(100.0 * 0.1 / month_factors)
    end

    it 'estimates correctly if billing period covers one partial months and one full month' do
      # skip
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '15/04/2019',
        '31/05/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'power'
      )
      month_factors = 0.1 * (0.7 * (12.0 / 22.0) + 0.3 * (4.0 / 8.0)) + 0.1
      expect(@energy_estimate.call).to eq(100.0 * 0.1 / month_factors)
    end
  end

  context 'with gas' do
    before(:all) do
      Profile.destroy_all
      (1..12).each do |month|
        FactoryBot.create(:profile, period: 'month', month: month, profile: 0.1, energy_type: 2)
        FactoryBot.create(:profile, period: 'wkend', month: month, profile: 0.3, energy_type: 2)
        FactoryBot.create(:profile, period: 'wkday', month: month, profile: 0.7, energy_type: 2)
      end
    end

    it 'estimates correctly if billing period covers one full month' do
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '1/04/2019',
        '30/04/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'gas'
      )
      expect(@energy_estimate.call).to eq(100.0 * 0.1 / 0.1)
    end

    it 'estimates correctly if billing period covers two partial months and two full month' do
      # skip
      @energy_estimate = Energy::PreviousMonthEnergyEstimate.new(
        100.0,
        '15/04/2019',
        '15/07/2019',
        Date.parse(Time.new.to_s).prev_month.month,
        'gas'
      )
      month_factors = 0.1 * (0.7 * (12.0 / 22.0) + 0.3 * (4.0 / 8.0)) +
        0.2 +
        0.1 * (0.7 * (11.0 / 23.0) + 0.3 * (4.0 / 8.0))
      expect(@energy_estimate.call).to be_within(0.0001).of(100.0 * 0.1 / month_factors)
    end
  end

end
require 'rails_helper'

RSpec.describe Energy::UserEmissions::MonthlySummary do
  PARAMS = {
    power_user_energy: '100.0',
    power_start_date: '1/4/2020',
    power_end_date: '30/4/2020',
    gas_user_energy: '',
    reg_petrol_user_energy: '',
    prem_petrol_user_energy: '',
    diesel_petrol_user_energy: '',
    reg_petrol_unit: '',
    prem_petrol_unit: '',
    diesel_unit: '',
    reg_petrol_period: '',
    prem_petrol_period: '',
    diesel_period: ''
  }

  before(:all) do
    EnergyType.destroy_all
    FactoryBot.create(:energy_type)
    FactoryBot.create(:energy_type, name: 'gas', id: 2)
    # Need this next line all EnergyType doesn't save - weird
    EnergyType.pluck(:id)

    EmissionFactor.destroy_all
    FactoryBot.create(:emission_factor, fuel_type: 'natural_gas', units: 'kgCO2/kWh', factor: 0.195)
    FactoryBot.create(:emission_factor)
    FactoryBot.create(:emission_factor, fuel_type: 'prem_petrol')
    FactoryBot.create(:emission_factor, fuel_type: 'diesel')

    HalfHourlyEmission.destroy_all

    Trader.destroy_all
    trader = Power::TraderData.new
    trader.call

    Profile.destroy_all

    FactoryBot.create(:profile, period: 'month', energy_type: 1)
    (1..12).each do |month|
      FactoryBot.create(:profile, period: 'month', month: month, profile: 0.1)
      FactoryBot.create(:profile, period: 'wkend', month: month, profile: 0.3)
      FactoryBot.create(:profile, period: 'wkday', month: month, profile: 0.7)
      (1..48).each do |trading_period|
        FactoryBot.create(:profile, period: trading_period, month: month)
         FactoryBot.create(:half_hourly_emission, period: trading_period, month: month)
      end
    end

    (1..12).each do |month|
      FactoryBot.create(:profile, period: 'month', month: month, profile: 0.1, energy_type: 2)
      FactoryBot.create(:profile, period: 'wkend', month: month, profile: 0.3, energy_type: 2)
      FactoryBot.create(:profile, period: 'wkday', month: month, profile: 0.7, energy_type: 2)
    end
  end

  context 'for power only' do
    it 'calculates power user emissions and previous month power' do
      # Power emissions = sum over 48 trading periods (
      #   previous month user energy *
      #   half hourly profile * <-- proportion of time in month for each half hour
      #   half hourly emissions factor )
      # Power emissions = 48 * 100 * 0.1 * 0.001 = 0.48
      emissions = Energy::UserEmissions::MonthlySummary.new(PARAMS)
      expect(emissions.call[0][:user_emission]).to eq(0.48)
      expect(emissions.previous_month_power).to eq(100.0)
    end
  end

  context 'for power and gas' do
    it 'calculates power and gas user emissions' do
      # Power emissions as per last example
      # Gas emissions =
      #   previous month user energy * <-- in kWh
      #   0.195 * <-- Gas emissions factor
      # Gas emissions = 100 * 0.195 = 19.5 kgCO2
      dashboard_params = PARAMS
      dashboard_params[:gas_user_energy] = '100'
      dashboard_params[:gas_start_date] = '1/4/2020'
      dashboard_params[:gas_end_date] = '30/4/2020'
      emissions = Energy::UserEmissions::MonthlySummary.new(dashboard_params)
      expect(emissions.call[0][:user_emission]).to eq(0.48)
      expect(emissions.call[1][:user_emission]).to eq(19.5)
    end
  end

  context 'for power and car' do
    it 'calculates power and car user emissions - litres' do
      # Power emissions as per first example
      # Car fuel emissions factor = 3 kgCO2/litre
      dashboard_params = PARAMS
      dashboard_params[:reg_petrol_user_energy] = '100'
      dashboard_params[:reg_petrol_unit] = 'Litres'
      dashboard_params[:reg_petrol_period] = 'month'
      emissions = Energy::UserEmissions::MonthlySummary.new(dashboard_params)
      expect(emissions.call[0][:user_emission]).to eq(0.48)
      expect(emissions.call[2][:user_emission]).to eq(300)
    end

    it 'calculates power and car user emissions - litres, week' do
      # Power emissions as per first example
      # Car fuel emissions factor = 3 kgCO2/litre
      dashboard_params = PARAMS
      dashboard_params[:reg_petrol_user_energy] = '100'
      dashboard_params[:reg_petrol_unit] = 'Litres'
      dashboard_params[:reg_petrol_period] = 'week'
      emissions = Energy::UserEmissions::MonthlySummary.new(dashboard_params)
      pp emissions.call
      expect(emissions.call[0][:user_emission]).to eq(0.48)
      # Multiply emissions by 4 to get monthly emissions
      expect(emissions.call[2][:user_emission]).to eq(300*4)
    end

    it 'calculates power and car user emissions - $' do
      # Power emissions as per first example
      # Car fuel emissions factor = 3 kgCO2/litre
      dashboard_params = PARAMS
      dashboard_params[:reg_petrol_user_energy] = '100'
      dashboard_params[:reg_petrol_unit] = '$'
      dashboard_params[:reg_petrol_period] = 'month'
      FactoryBot.create(:automotive_fuel_price, fuel_type: 'reg_petrol', fuel_price: 200.0)
      emissions = Energy::UserEmissions::MonthlySummary.new(dashboard_params)
      pp emissions.call
      expect(emissions.call[0][:user_emission]).to eq(0.48)
      # Multiply emissions by 4 to get monthly emissions
      expect(emissions.call[2][:user_emission]).to eq(100*3*100/200)
    end
  end
end
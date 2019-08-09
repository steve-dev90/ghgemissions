require 'rails_helper'

RSpec.describe Power::ClearedOfferDataEMI do

  TEST_FOLDER = './spec/services/power/emi_cleared_offers_test_data/'

  before(:all) do
    GenerationStation.destroy_all
    FactoryBot.create(:generation_station, poc: 'WRK2201 WRK0', emissions_factor: 0.1)
    TempHalfHourlyEmission.destroy_all
    HalfHourlyEmission.destroy_all
  end

  before(:each) do
    FileUtils.rm_rf(Dir['./spec/services/power/emi_cleared_offers_test_data/*'])
  end

  let(:HTTParty) { double(‘HTTParty’) }
  let(:Time) { double('Time') }

  # Note : after each example, the temp_half_hourly_emissions table is cleared.
  # In other specs the `tested_object.call` is in the before block. This is not possible
  # as doubles only exist on a per-test life cycle.
  # See https://relishapp.com/rspec/rspec-rails/docs/transactions

  it 'for one day it processes a single file' do
    data = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-07-18,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
    xml = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>"
    set_up_stubs(xml, data, 7, 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new(TEST_FOLDER)
    @cleared_offer.call
    expect(TempHalfHourlyEmission.find_by(month: 7, period: '1')[:energy]).to eq(25)
    expect(TempHalfHourlyEmission.count).to eq(1)
    expect(Dir[ TEST_FOLDER + '*'][0]).to eq(TEST_FOLDER + '20190718_Cleared_Offers.csv')
  end

  it 'for two days it processes a two files' do
    data_1 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-07-18,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
    xml_1 = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>"
    set_up_stubs(xml_1, data_1, 7, 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new(TEST_FOLDER)
    @cleared_offer.call

    data_2 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-07-19,1,NI,WRK2201 WRK0,WRKO,ENOF,60.000,.000,.000\r\n"
    xml_2 = "<xml><Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>
      <Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190719_Cleared_Offers.csv</Url></xml>"
    set_up_stubs(xml_2, data_2, 7, 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new(TEST_FOLDER)
    @cleared_offer.call

    expect(TempHalfHourlyEmission.find_by(month: 7, period: '1')[:energy]).to eq(55)
    expect(TempHalfHourlyEmission.count).to eq(1)
    expect(Dir[ TEST_FOLDER + '*']).to include(TEST_FOLDER + '20190718_Cleared_Offers.csv')
    expect(Dir[ TEST_FOLDER + '*']).to include(TEST_FOLDER + '20190719_Cleared_Offers.csv')
  end

  it 'processes the end of the year correctly' do
    data_1 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-12-30,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
    xml_1 = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20191230_Cleared_Offers.csv</Url>"
    set_up_stubs(xml_1, data_1, 12, 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
    @cleared_offer.call

    data_2 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-12-31,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
    xml_2 = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20191231_Cleared_Offers.csv</Url>"
    set_up_stubs(xml_2, data_2, 1, 2020)
    @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
    @cleared_offer.call

    data_3 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
    "2020-01-01,1,NI,WRK2201 WRK0,WRKO,ENOF,60.000,.000,.000\r\n"
    xml_3 =
    "<xml><Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20191231_Cleared_Offers.csv</Url>
    <Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20200101_Cleared_Offers.csv</Url></xml>"
    set_up_stubs(xml_3, data_3, 1, 2020)
    @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
    @cleared_offer.call
    expect(TempHalfHourlyEmission.find_by(month: 12, period: '1')[:energy]).to eq(50)
    expect(TempHalfHourlyEmission.find_by(month: 1, period: '1')[:energy]).to eq(30)
    expect(TempHalfHourlyEmission.count).to eq(2)
    expect(Dir[ TEST_FOLDER + '*']).to include(TEST_FOLDER + '20191230_Cleared_Offers.csv')
    expect(Dir[ TEST_FOLDER + '*']).to include(TEST_FOLDER + '20191231_Cleared_Offers.csv')
    expect(Dir[ TEST_FOLDER + '*']).to include(TEST_FOLDER + '20200101_Cleared_Offers.csv')
  end

  it 'processes once all days have been captured' do

    # Set up 30 days fo files
    (1..30).each do |d|
      day = d >= 10 ? d.to_s : "0#{d}"
      file = "201907#{day}_Cleared_Offers.csv"
      ProcessedEmiFile.create(file_name: file)
    end

    # Add a month 7 record to database, so it knows to process month 7
    FactoryBot.create(:temp_half_hourly_emission, month: 7)
    data = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-07-31,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
    xml = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190731_Cleared_Offers.csv</Url>"
    # Tests if previous month is complete
    set_up_stubs(xml, data, 8, 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new(TEST_FOLDER)
    @cleared_offer.call
    expect(HalfHourlyEmission.find_by(month: 7, period: '1', trader: 'WRKO')[:energy]).to eq(25)
    expect(TempHalfHourlyEmission.find_by(month: 7)).to be_nil
  end

  it 'handles errors' do
    allow(HTTParty).to receive_message_chain(:get, :[] => {'Error': 'Test'})
    allow(HTTParty).to receive_message_chain(:get, :code => 200)
    @cleared_offer = Power::ClearedOfferDataEMI.new(TEST_FOLDER)
    expect { @cleared_offer.call }.to raise_error(RuntimeError)
    allow(HTTParty).to receive_message_chain(:get, :[])
    allow(HTTParty).to receive_message_chain(:get, :code => 500)
    expect { @cleared_offer.call }.to raise_error(RuntimeError)
  end

  def set_up_stubs(xml, data, month, year)
    # To clear detect error method
    allow(HTTParty).to receive_message_chain(:get, :[])
    allow(HTTParty).to receive_message_chain(:get, :code => 200)
    # To get list of emi files
    allow(HTTParty).to receive_message_chain(:get, :body => xml)
    # To get csv file for processing
    allow(HTTParty).to receive_message_chain(:get, :gsub =>  data)
    # Sets the test current month and year
    allow(Time).to receive_message_chain(:new, :month => month)
    allow(Time).to receive_message_chain(:new, :year => year)
  end

end
require 'rails_helper'

RSpec.describe Power::ClearedOfferData do

  TEST_FOLDER = './spec/services/power/emi_cleared_offers_test_data/'

  before(:all) do
    GenerationStation.destroy_all
    FactoryBot.create(:generation_station, poc: 'WRK2201 WRK0', emissions_factor: 0.1)
    # TempHalfHourlyEmission.destroy_all
    FileUtils.rm_rf(Dir['./spec/services/power/emi_cleared_offers_test_data/*'])
  end

  let(:HTTParty) { double(‘HTTParty’) }
  let(:Time) { double('Time') }

  it 'for one day it processes a single file' do
    data = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
      "2019-07-18,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
    xml = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>"
    set_up_mocks(xml, data, 7, 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new(TEST_FOLDER)
    @cleared_offer.call
    expect(TempHalfHourlyEmission.find_by(month: 7, period: '1')[:energy]).to eq(25)
    expect(TempHalfHourlyEmission.count).to eq(1)
    expect(Dir[ TEST_FOLDER + '*'][0]).to eq(TEST_FOLDER + '20190718_Cleared_Offers.csv')
  end

  # it 'for two days it processes a two files' do
  #   data_1 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
  #     "2019-07-18,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
  #   xml_1 = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>"
  #   set_up_mocks(xml_1, data_1, 7, 2019)
  #   @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
  #   @cleared_offer.call

  #   data_2 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
  #     "2019-07-19,1,NI,WRK2201 WRK0,WRKO,ENOF,60.000,.000,.000\r\n"
  #   xml_2 = "<xml><Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>
  #     <Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190719_Cleared_Offers.csv</Url></xml>"
  #   set_up_mocks(xml_1, data_1, 7, 2019)
  #   @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
  #   @cleared_offer.call
  #   pp TempHalfHourlyEmission.all
  # end

  # it 'processes the end of the year correctly' do
  #   data_1 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
  #     "2019-12-31,1,NI,WRK2201 WRK0,WRKO,ENOF,50.000,.000,.000\r\n"
  #   xml_1 = "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20191231_Cleared_Offers.csv</Url>"
  #   set_up_mocks(xml_1, data_1, 12, 2019)
  #   @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
  #   @cleared_offer.call

  #   data_2 = "Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n" +
  #   "2020-01-01,1,NI,WRK2201 WRK0,WRKO,ENOF,60.000,.000,.000\r\n"
  #   xml_2 =
  #   "<xml><Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20191231_Cleared_Offers.csv</Url>
  #   <Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20200101_Cleared_Offers.csv</Url></xml>"
  #   set_up_mocks(xml_2, data_2, 1, 2020)
  #   @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
  #   @cleared_offer.call
  #   pp TempHalfHourlyEmission.all
  # end

  def set_up_mocks(xml, data, month, year)
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
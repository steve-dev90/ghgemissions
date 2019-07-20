require 'rails_helper'

RSpec.describe Power::ClearedOfferData do

  # before(:all) do
  #   HTTParty = double('HTTParty')
  #   allow(HTTParty).to receive(:url) { 'hello'}
  #   @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
  #   @cleared_offer.call
  # end

  let(:HTTParty) { double(‘HTTParty’) }
  let(:Time) { double('Time') }

  it 'saves the correct month' do
    allow(HTTParty).to receive_message_chain(:get, :[])
    allow(HTTParty).to receive_message_chain(:get, :code => 200)
    allow(HTTParty).to receive_message_chain(:get, :body => "<Url>https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/20190718_Cleared_Offers.csv</Url>")
    # Sets the test current month and year
    allow(Time).to receive_message_chain(:new, :month => 7)
    allow(Time).to receive_message_chain(:new, :year => 2019)
    @cleared_offer = Power::ClearedOfferDataEMI.new('./spec/services/power/emi_cleared_offers_test_data/')
    @cleared_offer.call
  end

end
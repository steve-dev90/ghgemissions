namespace :power do
  desc 'Import cleared offers from the emi website'
  task emi_cleared_data_daily_import: :environment do
    p 'hello there'
    url1 = 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/BidsAndOffers/Bids/2018/20181015_Bids.csv'
    url2 = 'https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list&prefix=Datasets/Wholesale/BidsAndOffers/Bids/2018'
    url3 = 'https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list'

    url4="https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/2019/20190101_Cleared_Offers.csv"
    url5='https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list&prefix=Datasets/Wholesale/Final_pricing/Cleared_Offers/2019'

    response = HTTParty.get(url5)
    # pp response.body
    # response.code, response.message, response.headers.inspect
    doc = Nokogiri::XML(response.body)
    blobs = doc.xpath('//Url')
    # pp blobs
    blobs.each do |blob|
      pp blob.content
    end

  end
end
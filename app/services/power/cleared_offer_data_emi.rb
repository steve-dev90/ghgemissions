class Power::ClearedOfferDataEMI

  def call
    p 'hello there'
    url5='https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list&prefix=Datasets/Wholesale/Final_pricing/Cleared_Offers/2019'

    response = HTTParty.get(url5)
    # pp response.body
    # response.code, response.message, response.headers.inspect
    doc = Nokogiri::XML(response.body)
    blobs = doc.xpath('//Url')
    blobs.each do |blob|
      pp blob
    end
  end

end
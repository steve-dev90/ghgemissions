class Power::ClearedOfferDataEMI
  # Electricity Authority emi endpoint for cleared offers folder
  # Note : excludes the year, added progamatically below
  EMI_CLEARED_OFFER_FOLDER = 'https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list&prefix=Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  #Electricity Authority emi file url path, excluding the file name
  EMI_CLEARED_OFFER_FILE = 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/'

  def call
    # Needs to be current date year + year(s) in database
    year = Date.parse(Time.new.to_s).year.to_s
    url = EMI_CLEARED_OFFER_FOLDER + year
    response = HTTParty.get(url)
    # NEED TO SELECT JUNE
    emi_files = Nokogiri::XML(response.body).xpath('//Url').reduce([]) do |files, blob|
      files << blob.content.gsub(EMI_CLEARED_OFFER_FILE,'')
    end
    pp emi_files

    # Get URL
    # Make sure you have the right year and month
    # get array of emi cleared offer files
    # get array of temp cleared offer files
    # Work out emi cleared offer files to load
    # Load and process emi file
    # Emi file gets saved in temp database
    # Send email

  end

end
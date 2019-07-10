class Power::ClearedOfferDataEMI
  # Electricity Authority emi endpoint for cleared offers folder
  # Note : excludes the year, added progamatically below
  EMI_CLEARED_OFFER_FOLDER = 'https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list&prefix=Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  #Electricity Authority emi file url path, excluding the file name
  EMI_CLEARED_OFFER_FILE = 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  FIRST_ROW_CLEARED_OFFER_FILE = 'Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n'
  EMI_IMPORTS_FOLDER = "./lib/assets/cleared_offer_data_emi/"

  def call

    get_available_emi_files.reject { |f| get_imported_emi_files.include? f }.each do |file|
      url = EMI_CLEARED_OFFER_FILE + file
      pp file
      emi_csv = CSV.parse(HTTParty.get(url).gsub(FIRST_ROW_CLEARED_OFFER_FILE,''))
      CSV.open(EMI_IMPORTS_FOLDER + file, "wb") do |csv|
        emi_csv.each { |row| csv << row }
      end

      csv = CSV.read(EMI_IMPORTS_FOLDER + file, converters: :numeric, headers:true)
      pp csv.map { |row| row['TradingPeriod'] }.uniq
    end



    # Get URL
    # Make sure you have the right year and month
    # get array of emi cleared offer files
    # get array of temp cleared offer files
    # Work out emi cleared offer files to load
    # Load and process emi file
    # Emi file gets saved in temp database
    # Send email
  end

  def get_imported_emi_files
    Dir[ EMI_IMPORTS_FOLDER + "*"].reduce([]) do |filenames, filepathname|
      filenames << File.basename(filepathname)
    end
  end

  def get_available_emi_files
    # need to get year + month combos in database
    # year = Date.parse(Time.new.to_s).year.to_s
    year_and_months = [{ year: '2019', month: '06' }]
    year_and_months.reduce([]) do |files, year_and_month|
      url = EMI_CLEARED_OFFER_FOLDER + year_and_month[:year]
      response = HTTParty.get(url)
      files.concat(process_emi_response(response, year_and_month))
    end
  end

  def process_emi_response(response, year_and_month)
    Nokogiri::XML(response.body).xpath('//Url').reduce([]) do |files, blob|
      if blob.content.include?(EMI_CLEARED_OFFER_FILE + year_and_month[:year] + year_and_month[:month])
        files << blob.content.gsub(EMI_CLEARED_OFFER_FILE,'')
      else
        files
      end
    end
  end

end
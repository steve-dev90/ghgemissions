class Power::ClearedOfferDataEMI
  # Electricity Authority emi endpoint for cleared offers folder, excluding year
  EMI_CLEARED_OFFER_FOLDER = 'https://emidatasets.blob.core.windows.net/publicdata?restype=container&comp=list&prefix=Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  #Electricity Authority emi file url path, excluding file name
  EMI_CLEARED_OFFER_FILE = 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  FIRST_ROW_CLEARED_OFFER_FILE = 'Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),ClearedFIR (MW),ClearedSIR (MW)\r\n'

  def initialize(folder)
    @folder = folder
  end

  def call
    # get_list_of_emi_files_to_process
    get_list_of_emi_files_to_process.each do |file|
      process_emi_file(file)
    end
    process_month_of_emissions_data
    # TaskSchedulerMailer.send_cleared_offer_processed_success_email.deliver
  end

  def process_emi_file(file)
    begin
      url = EMI_CLEARED_OFFER_FILE + file
      check_api_errors(url)
      emi_csv = CSV.parse(HTTParty.get(url).gsub(FIRST_ROW_CLEARED_OFFER_FILE,''))
      CSV.open(@folder + file, "wb") do |csv|
        emi_csv.each { |row| csv << row }
      end
      csv = CSV.read(@folder + file, converters: :numeric, headers:true)
      process_file = Power::ProcessClearedOfferCSV.new(csv, TempHalfHourlyEmission)
      process_file.call
    rescue RuntimeError, ArgumentError => e
      pp "#{e.class}: #{e.message}"
    end
  end

  def check_api_errors(url)
    if !HTTParty.get(url)["Error"].nil?
      raise RuntimeError, "Code: #{HTTParty.get(url)["Error"]["Code"]}
        Message: #{HTTParty.get(url)["Error"]["Message"]}"
    end
    raise RuntimeError, "EMI api response#{HTTParty.get(url).code}" unless HTTParty.get(url).code == 200
  end

  def get_list_of_emi_files_to_process
    # pp get_available_emi_files
    get_available_emi_files.reject { |f| get_processed_emi_files.include? f }
  end

  def get_processed_emi_files
    Dir[ @folder + "*"].reduce([]) do |filenames, filepathname|
      filenames << File.basename(filepathname)
    end
  end

  def get_available_emi_files
    get_years_and_months.reduce([]) do |files, year_and_month|
      # Get list of blobs in folder
      url = EMI_CLEARED_OFFER_FOLDER + year_and_month[:year]
      check_api_errors(url)
      response = HTTParty.get(url)
      # pp process_emi_response(response, year_and_month)
      files.concat(process_emi_response(response, year_and_month))
    end
  end

  def get_years_and_months
    months = (TempHalfHourlyEmission.pluck(:month).uniq << Time.new.month).uniq
    todays_year = Time.new.year
    months.reduce([]) do |years_and_months, month|
      if months.include?(1) && month == 12
        years_and_months << { year: (todays_year - 1).to_s, month: get_month(month) }
      else
        years_and_months << { year: todays_year.to_s, month: get_month(month) }
      end
    end
  end

  def get_month(month)
    return month.to_s if month >= 10
    "0#{month}"
  end

  def process_emi_response(response, year_and_month)
    Nokogiri::XML(response.body).xpath('//Url').reduce([]) do |files, blob|
      # pp "kJuuuu"
      # pp blob.content
      # pp EMI_CLEARED_OFFER_FILE + year_and_month[:year] + year_and_month[:month]
      if blob.content.include?(EMI_CLEARED_OFFER_FILE + year_and_month[:year] + year_and_month[:month])
        files << blob.content.gsub(EMI_CLEARED_OFFER_FILE,'')
        # pp "N", files
      else
        files
      end
    end
  end


  def process_month_of_emissions_data


  end

end
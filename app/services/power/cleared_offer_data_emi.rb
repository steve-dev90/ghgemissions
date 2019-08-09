# frozen_string_literal: true

class Power::ClearedOfferDataEMI
  # Electricity Authority emi endpoint for cleared offers folder, excluding year
  EMI_CLEARED_OFFER_FOLDER = 'https://emidatasets.blob.core.windows.net/' \
                             'publicdata?restype=container&comp=list&prefix=' \
                             'Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  # Electricity Authority emi file url path, excluding file name
  EMI_CLEARED_OFFER_FILE = 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/Final_pricing/Cleared_Offers/'
  FIRST_ROW_CLEARED_OFFER_FILE = 'Date,TradingPeriod,Island,PointOfConnection,Trader,Type,ClearedEnergy (MW),' \
                                 'ClearedFIR (MW),ClearedSIR (MW)\r\n'

  def initialize(folder)
    @folder = folder
  end

  def call
    files = list_of_emi_files_to_process
    files.each do |file|
      process_emi_file(file)
      pp "Processed #{file}"
    end
    TaskSchedulerMailer.send_cleared_offer_processed_success_email(files).deliver
    process_month_of_emissions_data
  end

  def process_emi_file(file)
    CSV.open(@folder + file, 'wb') do |csv|
      CSV.parse(emi_response(file)).each { |row| csv << row }
    end
    csv = CSV.read(@folder + file, converters: :numeric, headers: true)
    process_file = Power::ProcessClearedOfferCSV.new(csv, TempHalfHourlyEmission)
    process_file.call
    ProcessedEmiFile.create(file_name: file)
  rescue RuntimeError, ArgumentError => error
    TaskSchedulerMailer.send_cleared_offer_error_email(file, error).deliver
  end

  def emi_response(file)
    url = EMI_CLEARED_OFFER_FILE + file
    check_api_errors(url)
    HTTParty.get(url).gsub(FIRST_ROW_CLEARED_OFFER_FILE, '')
  end

  def check_api_errors(url)
    response = HTTParty.get(url)
    return raise "EMI api response #{response.code}" unless response.code == 200
    return if response['Error'].nil?

    raise "Code: #{response['Error']['Code']} Message: #{response['Error']['Message']}"
  end

  def list_of_emi_files_to_process
    available_emi_files.reject { |f| processed_emi_files.include? f }
  end

  def processed_emi_files
    ProcessedEmiFile.pluck(:file_name)
  end

  def available_emi_files
    years_and_months.reduce([]) do |files, year_and_month|
      url = EMI_CLEARED_OFFER_FOLDER + year_and_month[:year]
      check_api_errors(url)
      response = HTTParty.get(url)
      files.concat(process_emi_response(response, year_and_month))
    end
  end

  def years_and_months
    months = (TempHalfHourlyEmission.pluck(:month).uniq << Time.new.month).uniq
    todays_year = Time.new.year
    months.reduce([]) do |years_and_months, month|
      years_and_months << if months.include?(1) && month == 12
                            { year: (todays_year - 1).to_s, month: two_digit_month(month) }
                          else
                            { year: todays_year.to_s, month: two_digit_month(month) }
                          end
    end
  end

  def two_digit_month(month)
    return month.to_s if month >= 10

    "0#{month}"
  end

  def process_emi_response(response, year_and_month)
    Nokogiri::XML(response.body).xpath('//Url').reduce([]) do |files, blob|
      if blob.content.include?(EMI_CLEARED_OFFER_FILE + year_and_month[:year] + year_and_month[:month])
        files << blob.content.gsub(EMI_CLEARED_OFFER_FILE, '')
      else
        files
      end
    end
  end

  def process_month_of_emissions_data
    last_month_january_check
    pp "FFGG", last_month_files
    return unless last_month_files == Time.days_in_month(@last_month, @last_month_year)

    transfer_records
    TaskSchedulerMailer.send_cleared_offer_monthly_processing_complete_email(@last_month).deliver
  end

  def last_month_files
    ProcessedEmiFile
      .all
      .select{ |r| r.file_name.include?(two_digit_month(@last_month))}
      .size
    # "#{@folder}#{@last_month_year}#{two_digit_month(@last_month)}*_Cleared_Offers.csv"
  end

  def transfer_records
    TempHalfHourlyEmission.where(month: @last_month).each do |record|
      hash = { month: record.month, period: record.period, trader: record.trader,
               emissions: record.emissions, energy: record.energy, emissions_factor: record.emissions_factor }
      half_hourly_emission = HalfHourlyEmission.find_or_create_by(month: record.month, period: record.period, trader: record.trader)
      pp '*** Record not Valid ***', record, half_hourly_emission.errors.messages unless half_hourly_emission.update_attributes(hash)
    end
    TempHalfHourlyEmission.where(month: @last_month).destroy_all
  end

  def last_month_january_check
    @last_month = Time.now.month - 1
    @last_month_year = Time.now.year
    return if Time.new.month > 1

    @last_month = 12
    @last_month_year = Time.new.year - 1
  end
end

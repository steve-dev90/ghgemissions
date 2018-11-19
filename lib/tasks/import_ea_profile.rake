require 'roo'

desc 'Import EA rps profile for GXP CPK0111 stored in spreadsheet'
task import_ea_profile: :environment do
  profile = ImportProfile.new('./lib/assets/CPK0111 RPS.xlsx')
  profile.call
end

class ImportProfile
  def initialize(file)
    @file = file
    @profile_records = []
  end

  def call
    get_profile_records
    get_profile_divided_by_total_profile
    pp @profile_records
    save_record
  end

  def get_profile_records
    Roo::Spreadsheet.open(@file).sheet('Sheet1').each do |row|
      next if row[0] == 'GXP'
      record = extract_record(row)
      index = record_index(record)
      if index.nil?
        create_new_record(record)
      else
        update_record(index, record)
      end      
    end
  end  

  def extract_record(row)
    {
      trading_period: row[4],
      profile: row[5]
    }
  end  

  def record_index(record)
    @profile_records.index do |profile_record|
      profile_record[:trading_period] == record[:trading_period]
    end  
  end  

  def create_new_record(record)
    @profile_records << record
  end  

  def update_record(index, record)
    @profile_records[index][:profile] += record[:profile]
  end 
  
  def get_profile_sum
    @profile_records.sum{ |record| record[:profile] }
  end

  def get_profile_divided_by_total_profile
    sum = get_profile_sum
    @profile_records.each{ |record| record[:profile] = record[:profile] / sum }
  end  

  def save_record
    @profile_records.each do |record|
      profile = Profile.find_or_create_by(trading_period: record[:trading_period])
      profile.update_attributes(record)
    end
  end  
end
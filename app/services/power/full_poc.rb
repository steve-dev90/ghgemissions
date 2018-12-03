class Power::FullPoc
  EXCLUDED_CONNECTION_TYPES = %w[Embedded].freeze
  
   def initialize(file)
    @file = file
  end

  def call
    Roo::Spreadsheet.open(@file).sheet('POC list').reduce([]) do |records, row|
      skip_row(row) ? records : records << get_record(row)     
    end
  end

  def skip_row(row)
    row[0] == 'Station_Name' || 
    EXCLUDED_CONNECTION_TYPES.include?(row[4]) ||
    row[8].blank? 
  end

  def get_record(row)
    { station_name: row[0],
      full_poc: row[8] }
  end
end
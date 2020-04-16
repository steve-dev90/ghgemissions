class Energy::RawProfileData
  attr_reader :input_path, :output_path, :profile_loc
  attr_accessor :file_processor

  def initialize(data_processor, input_path, output_path, profile_loc)
    @input_path = input_path
    @output_path = output_path
    @profile_loc = profile_loc
    @data_processor = data_processor
  end

  def call
    File.delete(@output_path) if File.exist?(@output_path)
    process_raw_profile_data
  end

  def process_raw_profile_data
    @data_processor.process_raw_profile_data(self)
  end

  def write_to_csv(row)
    CSV.open(@output_path, "a") do |csv|
      csv << row
    end
  end
end
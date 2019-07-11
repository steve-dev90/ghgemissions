class Power::ClearedOfferData
  def initialize(files)
    @files = Dir[files]
  end

  # This method assumes there is only one file per trading date
  def call
    @files.each do |file|
      begin
        csv = CSV.read(file, converters: :numeric, headers:true)
        if csv[0].nil?
          raise 'File is empty'
          break
        end
        puts "File: #{file} CSV read completed"
        # obtain_half_hourly_emission_records(csv)
        # save_records
        process_file = Power::ProcessClearedOfferCSV.new(csv, HalfHourlyEmission)
        process_file.call
        puts "File: #{file} saved to database"
      rescue RuntimeError => e
        puts "#{e.class}: #{e.message}"
      end
    end
    puts 'All files processed!'
  end
end

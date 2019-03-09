class Power::ProcessRps
  PROFILE_GXP = 'CPK0111'
  FILE = './lib/assets/CPK0111_RPS.csv'

  def initialize(files)
    @files = Dir[files]
  end

  def call
    file.delete(FILE) if File.exist?(FILE)
    @files.each do |file|
      process_file(@files[0])
      puts "Processed #{@file}"
    end
  end

  def process_file(file)
    CSV.foreach(file) do |row|
      write_to_csv(row) if row[0] == PROFILE_GXP
    end
  end

  def write_to_csv(row)
    CSV.open(FILE, "a") do |csv|
      csv << row
    end
  end
end
class Power::ProcessRps
  PROFILE_GXP = 'CPK0111'
  FILE = './lib/assets/CPK0111_RPS.csv'

  def initialize(files)
    @files = Dir[files]
  end

  def call
    begin
      raise 'There should be 12 profile files' if @files.count != 12
      File.delete(FILE) if File.exist?(FILE)
      @files.each do |file|
        raise 'The file should named NZRM_E_RMPW_RPSBORD...' unless file.include?('NZRM_E_RMPW_RPSBORD')
        process_file(file)
        puts "Processed #{file}"
      end
    rescue RuntimeError => e
      puts "#{e.class}: #{e.message}"
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
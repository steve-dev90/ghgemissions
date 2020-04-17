# For processing raw Electricity Authority power profiles
# Generates a single file containing profile data for a
# single GXP, for 12 months
class Power::PowerProfileProcessor
  def process_raw_profile_data(context)
    begin
      raise 'There should be 12 profile files' if Dir[context.input_path].count != 12
      Dir[context.input_path].each do |file|
        raise 'The file should named NZRM_E_RMPW_RPSBORD...' unless file.include?('NZRM_E_RMPW_RPSBORD')
        process_each_file(file, context)
        puts "Processed #{file}"
      end
    rescue RuntimeError => e
      puts "#{e.class}: #{e.message}"
    end
  end

  def process_each_file(file, context)
    CSV.foreach(file) do |row|
      context.write_to_csv(row) if row[0] == context.profile_loc
    end
  end
end
namespace :power do
  desc 'Imports exported_half_hourly_emissions.csv into half_hourly_emissions table'
  task import_half_hourly_emissions_table_csv: :environment do
    HalfHourlyEmission.destroy_all
    FILE = "./lib/assets/exported_half_hourly_emissions.csv"
    csv = CSV.read(FILE, converters: :numeric)
    csv.each do |row|
      half_hourly_emission = HalfHourlyEmission.find_or_create_by(month: row[4], period: row[5], trader: row[0])
      record = {trader: row[0], emissions: row[1], energy: row[2],
      emissions_factor: row[3], month: row[4], period: row[5]}
      pp '*** Record not Valid ***', record, half_hourly_emission.errors.messages unless half_hourly_emission.update_attributes(record)
    end
  end
end
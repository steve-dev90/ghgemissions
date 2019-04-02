namespace :power do
  desc 'Export half_hourly_emissions table from dev'
  task export_half_hourly_emissions_table: :environment do
    FILE = "./lib/assets/exported_half_hourly_emissions.csv"
    File.delete(FILE) if File.exist?(FILE)
    HalfHourlyEmission.find_each do |record|
      CSV.open(FILE, "a") do |csv|
        csv << [record[:trader], record[:emissions],
          record[:energy], record[:emissions_factor],
          record[:month], record[:period]]
      end
    end
  end
end
desc "Create daily emissions factor"
task :create_half_hourly_emissions_factors => :environment do
  hh_emissions_factors = ImportHHEmissionsFactors.new
  hh_emissions_factors.call
end

# Processes a single trading day of cleared_offers data. This data is then
# deleted from the cleared_offers table
class ImportHHEmissionsFactors
  def call
    @hh_emissions_factors = ClearedOffer
      .select("date, trading_period, trader, sum(emissions) as emissions, sum(cleared_energy) as cleared_energy")
      .group("date, trading_period, trader")
      .order(:trading_period)
    @hh_energy = ClearedOffer
      .select("trading_period, sum(cleared_energy) as cleared_energy")
      .group("trading_period ")
      .order(:trading_period)
    pp @hh_emissions_factors.last
    pp @hh_energy.last  
  end
end



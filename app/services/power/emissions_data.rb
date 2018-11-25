# Processes a single trading day of cleared_offers data. This data is then
# deleted from the cleared_offers table.
class Power::EmissionsData
  def call
    HalfHourlyEmission.destroy_all
    (1..ClearedOffer.maximum(:trading_period)).each do |trading_period|
      get_hh_emissions_by_trader(trading_period).each do |record|
        hh_emissions = get_hh_emissions(record)
        hh_emissions[:emissions_factor] = (hh_emissions[:emissions] / get_energy(trading_period))
        hh_emissions[:emissions_factor] = hh_emissions[:emissions_factor].round(6)
        HalfHourlyEmission.create(hh_emissions)
      end
    end
  end

  # Returns aggregated cleared_offers by trader for a given trading period.
  def get_hh_emissions_by_trader(trading_period)
    ClearedOffer
      .select('date, trading_period, trader, sum(emissions) as emissions, sum(cleared_energy) as cleared_energy')
      .group('date, trading_period, trader')
      .order(:trading_period)
      .where(trading_period: trading_period)
  end

  def get_hh_emissions(record)
    { date: record[:date],
      trading_period: record[:trading_period],
      trader: record[:trader],
      emissions: record[:emissions],
      energy: record[:cleared_energy] }
  end

  # Returns total cleared energy for trading period in MWh.
  # The 0.5 factor converts MW to MWh.
  def get_energy(trading_period)
    ClearedOffer
      .select('trading_period, sum(cleared_energy) as cleared_energy')
      .group('trading_period')
      .order(:trading_period)
      .where(trading_period: trading_period)
      .first[:cleared_energy] * 0.5
  end
end

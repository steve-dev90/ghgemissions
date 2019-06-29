class Power::ProcessClearedOfferCSV
  def initialize(csv)
    @csv = csv
    @half_hourly_emission_record = []
  end

  def call
    obtain_half_hourly_emission_records
    save_records
  end

  # Note: cleared energy converted from MW to MWh, by multiplying by 0.5
  def obtain_half_hourly_emission_records
    trading_periods = @csv.map { |row| row['TradingPeriod'] }.uniq
    @month = Date.parse(@csv[0]['Date']).month
    trading_periods.each do |trading_period|
      rows = @csv.select { |row| row['TradingPeriod'] == trading_period && row['Type'] == 'ENOF' }
      energy = rows.sum { |row| row["ClearedEnergy (MW)"] * 0.5 }
      (HalfHourlyEmission.where(month: @month, period: trading_period).pluck(:trader) +
        rows.map { |row| row["Trader"] }).uniq.each do |trader|
        for_each_trader(rows, trading_period, trader, energy)
      end
    end
  end

  def for_each_trader(rows, trading_period, trader, energy)
    emissions = rows
                  .select { |row| row['Trader'] == trader }
                  .sum { |row| get_emissions(row['ClearedEnergy (MW)'] * 0.5, row['PointOfConnection'] )}
    add_record(trading_period, trader, energy, emissions)
  end

  def add_record(trading_period, trader, energy, emissions)
    previous_record = HalfHourlyEmission.find_by(month: @month, period: trading_period, trader: trader)
    unless previous_record.nil?
      energy = energy + previous_record[:energy] || 0.0
      emissions = emissions + previous_record[:emissions] || 0.0
    end
    return if emissions.zero?
    @half_hourly_emission_record << { month: @month,
                                      period: trading_period.to_s,
                                      trader: trader,
                                      emissions: emissions,
                                      energy: energy,
                                      emissions_factor: emissions / energy }
  end

  def get_emissions(cleared_energy, poc)
    # Note GenerationStation only has fossil fuel power stations
    emissions_factor = GenerationStation.where(poc: poc).first &&
                       GenerationStation.where(poc: poc).first[:emissions_factor]
    return 0.0 if emissions_factor.nil?

    (cleared_energy * (emissions_factor || 0)).round(2)
  end

  def save_records
    @half_hourly_emission_record.each do |record|
      half_hourly_emission = HalfHourlyEmission.find_or_create_by(month: @month, period: record[:period], trader: record[:trader])
      pp '*** Record not Valid ***', record, half_hourly_emission.errors.messages unless half_hourly_emission.update_attributes(record)
    end
    # Reset for the next csv file!
    @half_hourly_emission_record=[]
  end
end
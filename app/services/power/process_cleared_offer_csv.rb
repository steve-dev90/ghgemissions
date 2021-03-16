class Power::ProcessClearedOfferCSV
  def initialize(csv, half_hourly_emission_table)
    @csv = csv
    @half_hourly_emission_record = []
    @month = Date.parse(@csv[0]['Date']).month
    @trading_periods = @csv.map { |row| row['TradingPeriod'] }.uniq
    @half_hourly_emission_table = half_hourly_emission_table
  end

  def call
    raise ArgumentError, "csv only contains header" if @csv[0].nil?

    @csv = calculate_emissions_and_fuel_type_by_cleared_energy_offer
    # pp @csv.map{ |a| a}
    obtain_half_hourly_emission_records
    # pp @half_hourly_emission
    save_records
  end

  def calculate_emissions_and_fuel_type_by_cleared_energy_offer
    @csv.each do |row|
      next if row['Type'] != 'ENOF'

      if GenerationStation.where(poc: row['PointOfConnection']).empty?
        raise "Point of connection does not exist, poc: #{row['PointOfConnection']}"
      end

      row['fuel_type'] = GenerationStation.where(poc: row['PointOfConnection']).first[:fuel_name]
      row['emissions'] = get_emissions(row['ClearedEnergy (MW)'] * 0.5, row['PointOfConnection'] )
    end
  end

  def get_emissions(cleared_energy, poc)
    emissions_factor = GenerationStation.where(poc: poc).first[:emissions_factor]
    return 0.0 if emissions_factor.nil?

    (cleared_energy * (emissions_factor || 0)).round(2)
  end

  # Note: cleared energy converted from MW to MWh, by multiplying by 0.5
  def obtain_half_hourly_emission_records
    @fuel_types = @csv.map { |row| row['fuel_type'] }.uniq
    @trading_periods.each do |trading_period|
      rows = @csv.select { |row| row['TradingPeriod'] == trading_period && row['Type'] == 'ENOF' }
      energy = rows.sum { |row| row["ClearedEnergy (MW)"] * 0.5 }
      for_each_fuel_type(rows, energy, trading_period)
    end
  end

  def for_each_fuel_type(rows, energy, trading_period)
    @fuel_types.each do |fuel_type|
      emissions = rows
                .select { |row| row['fuel_type'] == fuel_type }
                .sum { |row| row['emissions'] }
      add_record(trading_period, fuel_type, energy, emissions)
    end
  end

  def add_record(trading_period, fuel_type, energy, emissions)
    previous_record = @half_hourly_emission_table.find_by(month: @month, period: trading_period, fuel_type: fuel_type)
    unless previous_record.nil?
      energy = energy + previous_record[:energy] || 0.0
      emissions = emissions + previous_record[:emissions] || 0.0
    end
    return if emissions.zero?
    @half_hourly_emission_record << { month: @month,
                                      period: trading_period.to_s,
                                      fuel_type: fuel_type,
                                      emissions: emissions,
                                      energy: energy,
                                      emissions_factor: emissions / energy }
  end

  def save_records
    @half_hourly_emission_record.each do |record|
      half_hourly_emission = @half_hourly_emission_table.find_or_create_by(month: @month, period: record[:period], fuel_type: record[:fuel_type])
      pp '*** Record not Valid ***', record, half_hourly_emission.errors.messages unless half_hourly_emission.update(record)
    end
    # Reset for the next csv file!
    @half_hourly_emission_record=[]
  end
end
class Power::GenerationData
  def initialize(file, sheet)
    @file = file
    @sheet = sheet
  end

  def call
    Roo::Spreadsheet.open(@file).sheet(@sheet).each do |row|
      next if skip_row(row)

      check_efficiency(row)
      check_emissions_factor(row)
      record = get_record(row)
      record[:emissions_factor] = get_emissions_factor(
        record[:fuel_name],
        record[:primary_efficiency],
        record[:emissions_factor]
      )
      save_record(record)
    end
  end

  def skip_row(row)
    row[0] == 'Station_Name'
  end

  def check_efficiency(row)
    return unless %w[natural_gas coal diesel].include? row[5]

    raise 'thermal fuel has no heat rate' if row[6].nil?
    raise 'thermal fuel heat rate out of bounds' if row[6] < 5000 || row[6] > 15_000
  end

  def check_emissions_factor(row)
    return unless ['geothermal'].include? row[5]

    raise 'geothermal has no emissions factor' if row[7].nil?
    raise 'geothermal emissions factor out of bounds' if row[7] > 0.5
  end

  def get_record(row)
    { station_name: row[0],
      poc: row[8],
      generation_type: row[3],
      fuel_name: row[5],
      primary_efficiency: row[6] || 0,
      emissions_factor: row[7] }
  end

  # Note : heat rates are in kJ/KWh = MJ/MWh
  # Emissions factors are in tCO2/MWh
  # 1 TJ = 10**6 MJ
  def get_emissions_factor(fuel_name, primary_efficiency, emissions_factor)
    # pp fuel_name, emissions_factor
    return emissions_factor if fuel_name == 'geothermal'
    return 0 if EmissionFactor.where('fuel_type = ? AND units = ?', fuel_name, 'tCO2/TJ').empty?

    EmissionFactor
      .where('fuel_type = ? AND units = ?', fuel_name, 'tCO2/TJ')
      .first[:factor] *
      primary_efficiency / 10**6
  end

  # Note : record only saved to database if the station name is on the POC list
  def save_record(record)
    station = GenerationStation.find_or_create_by(station_name: record[:station_name], poc: record[:poc])
    pp '*** Record not Valid ***', record, station.errors.messages unless station.update(record)
  end
end

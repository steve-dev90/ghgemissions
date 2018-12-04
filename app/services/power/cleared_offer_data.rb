class Power::ClearedOfferData
  def initialize(file)
    @file = file
  end

  def call
    ClearedOffer.destroy_all
    CSV.foreach(@file) do |row|
      next if row[0] == 'Date' || row[5] != 'ENOF'

      record = get_record(row)
      record[:emissions] = get_emissions(record[:cleared_energy], record[:poc])
      save_record(record)
    end
  end

  def get_record(row)
    { date: row[0],
      trading_period: row[1],
      island: row[2],
      poc: row[3],
      trader: row[4],
      offer_type: row[5],
      cleared_energy: row[6].to_f }
  end

  def get_emissions(cleared_energy, poc)
    emissions_factor = GenerationStation.where(poc: poc)&.first && 
      GenerationStation.where(poc: poc).first[:emissions_factor]
    return 0.0 if emissions_factor.nil?
    (cleared_energy.to_f * 0.5 * (emissions_factor || 0)).round(2)
  end

  def save_record(record)
    cleared_offer = ClearedOffer.new(record)
    pp '*** Record not Valid ***', record, cleared_offer.errors.messages unless cleared_offer.save
  end
end

#Run at set up to add energy types to db
class Energy::EnergyTypesData
  ENERGY_TYPES = [{name: 'power' }, { name: 'gas' }].freeze

  def call
    save_records
    puts 'EnergyTypes table updated!'
  end

  def save_records
    ENERGY_TYPES.each do |record|
      energy_type = EnergyType.find_or_create_by(name: record[:name])
      pp '*** Record not Valid ***', record, energy_type.errors.messages unless energy_type.update_attributes(record)
    end
  end
end

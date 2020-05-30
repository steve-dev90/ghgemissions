class Power::TraderData
  TRADERS = [{ code: 'GENE', name: 'Genesis Energy' },
             { code: 'CTCT', name: 'Contact Energy' },
             { code: 'MRPL', name: 'Mighty River Power' },
             { code: 'TODD', name: 'Todd Energy' },
             { code: 'TUAR', name: 'Tuaropaki Power  Company' },
             { code: 'NAPJ', name: 'Nga Awa Purua JV' }].freeze

  def call
    save_records
    puts 'Trader table updated!'
  end

  def save_records
    TRADERS.each do |record|
      trader = Trader.find_or_create_by(code: record[:code])
      pp '*** Record not Valid ***', record, trader.errors.messages unless trader.update(record)
    end
  end
end

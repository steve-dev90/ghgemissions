class Power::TraderData
  TRADERS = [ {code: 'GENE', name: 'Genesis Energy'},
              {code: 'CTCT', name: 'Contact Enegy'},
              {code: 'MRPL', name: 'Mighty River Power'},
              {code: 'TODD', name: 'Todd Energy'},
              {code: 'OTHR', name: 'Other'} ].freeze

  def call
    save_records
    puts 'Trader table updated!'
  end

  def save_records
    TRADERS.each do |record|
      trader = Trader.find_or_create_by(code: record[:code])
      pp '*** Record not Valid ***', record, trader.errors.messages unless trader.update_attributes(record)
    end
  end
end
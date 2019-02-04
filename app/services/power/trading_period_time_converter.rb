module Power::TradingPeriodTimeConverter
  def convert_trading_period_to_24hrtime(trading_period)
    first_cut = (trading_period.to_f / 2.0 - 0.5)
    hours = first_cut < 10 ? "0#{first_cut.to_s[0]}:" : "#{first_cut.to_s.slice(0,2)}:"
    minutes = (first_cut % 1).zero? ? "00" : "30"
    hours + minutes
  end
end
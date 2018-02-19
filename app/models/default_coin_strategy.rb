class DefaultCoinStrategy

  def find_coins(volume, market_cap, date, num_coins = 5)
    dates = HistoricalDatum.where(:date => date).where('volume > ? and market_cap > ?', volume, market_cap).limit(num_coins)
    dates.collect(&:currency_id)
  end

end

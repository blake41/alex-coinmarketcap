class Calculator

  attr_reader :coin_ids, :date, :price_column, :combined_data

  def initialize(date, coin_ids)
    @date = date
    @coin_ids = coin_ids
    @price_column = :open
  end

  def calc_return_per_coin
    get_data
    rois = {}
    coin_ids.each do |coin_id|
      rois[coin_id] = calc_roi(coin_id)
    end
    rois
  end

  def opening_day(coin_id)
    day_row(date, coin_id)
  end

  def calc_roi(coin_id)
    (closing_day(coin_id) - opening_day(coin_id)) / opening_day(coin_id)
  end

  def closing_day(coin_id)
    day_row(date + 6.days, coin_id)
  end

  def get_data
    @combined_data = HistoricalDatum.where(:date => [date, date + 6.days], :currency_id => coin_ids)
  end

  def day_row(day, coin_id)
    combined_data.where(:currency_id => coin_id, :date => day).last.send(price_column)
    # HistoricalDatum.where(:date => day, :currency_id => coin_id).last.send(price_column)
  end

end

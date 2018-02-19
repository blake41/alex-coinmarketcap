class Simulator

  attr_reader :date, :volume, :market_cap, :calculator, :funds, :sum, :results, :cs

  def initialize(market_cap = 10000000, volume = 500000, funds = 10000, coin_strategy = DefaultCoinStrategy.new)
    @market_cap = market_cap
    @volume = volume
    @funds = funds
    @results = {}
    @cs = coin_strategy
  end

  def run(start_date = '2017-01-01')
    @date = Date.parse(start_date)
    52.times do |i|
      week = i + 1
      @results[week] = run_week((date + (week * 7).days), week)
    end
    write_results
  end

  def write_results
    File.open("public/results.json","w") do |f|
      f.write(results.to_json)
    end
  end

  def run_week(date, week)
    ids = find_coins(date)
    @calculator = Calculator.new(date, ids)
    rois = calculator.calc_return_per_coin
    data = invest(ids, rois, last_weeks_total(week))
    {:rois => rois, :sum => data[:sum], :amounts => data[:amounts]}
  end

  def last_weeks_total(week)
    week = results[week - 1]
    if week
      return week[:sum]
    else
      return funds
    end
  end

  def find_coins(date)
    cs.find_coins(volume, market_cap, date)
  end

  def invest(ids, rois, funds)
    amt_per_coin = funds.to_f / ids.count
    sum = 0
    amounts = {}
    rois.each do |key, value|
      new_value = (1 + value) * amt_per_coin
      sum += new_value
      amounts[key] = new_value
    end
    {:amounts => amounts, :sum => sum}
  end

end

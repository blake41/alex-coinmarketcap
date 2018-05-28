class Scraper

  attr_reader :bot, :date, :url

  def initialize(url = 'https://coinmarketcap.com')
    @bot = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    @url = url
  end

  def update_data
    if get_last_day_run < Date.today
      date_to_run = get_last_day_run + 1.day
    else
      puts "already up to date"
      return
    end
    run(date_to_run.strftime("%Y%m%d"))
  end

  def run(date)
    page = bot.get("#{url}/all/views/all/")
    page.links_with(:href => /currencies\/\w+-?\w*-?\w*\/\z/).uniq {|link| link.href}.each do |link|
      get_data_for_currency(link, date)
    end
  end

  def add_new_coins(date = 20130428)
    # Currency.last.destroy if Currency.count > 0
    page = bot.get("#{url}/all/views/all/")
    page.links_with(:href => /currencies\/\w+-?\w*-?\w*\/\z/).uniq {|link| link.href}.each do |link|
      next if Currency.find_by_ticker(link.text)
      get_data_for_currency(link, date)
    end
  end

  def get_data_for_currency(link, start_date)
    currency_page = mechanize_request {link.click}
    uri = link.uri
    currency_name = uri.path.match(/\/\w+\/(\w+-?*\w*-?\w*)/)[1]
    today = Date.today.strftime("%m%d")
    currency_url = "#{url}/currencies/#{currency_name}/historical-data/?start=#{start_date}&end=2018#{today}"
    data = mechanize_request {bot.get(currency_url)}
    return if data.nil?
    ticker = data.css(".hidden-xs.bold").text.gsub("(", "").gsub(")","")
    if currency_name == "batcoin"
      ticker = "BTA"
    end
    c = Currency.find_or_create_by(:name => currency_name, :ticker => ticker)
    data.css('tbody')[0].children.select(&:element?).each do |row|
      cells = row.children.select(&:element?)
      begin
      row = c.historical_datum.new(:date => cells[0].children[0].text, :open => cells[1].children[0].text, :high => cells[2].children[0].text, :low => cells[3].children[0].text, :close => cells[4].children[0].text, :volume => cells[5].children[0].text.gsub(",", "").to_i, :market_cap => cells[6].children[0].text.gsub(",", "").to_i)
    rescue
      next
    end
      if row.valid?
        row.save
      end
    end
  end

  def get_last_day_run
    HistoricalDatum.where(:currency_id => 171).order("date desc").first.date
  end

  def mechanize_request
    begin
      retries ||= 0
      page = yield
    rescue
      sleep 5
      retry if (retries += 1) < 3
      binding.pry
    end
    return page
  end

end

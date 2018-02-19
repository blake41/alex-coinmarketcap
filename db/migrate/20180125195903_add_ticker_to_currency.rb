class AddTickerToCurrency < ActiveRecord::Migration[5.0]
  def change
    add_column :currencies, :ticker, :string
  end
end

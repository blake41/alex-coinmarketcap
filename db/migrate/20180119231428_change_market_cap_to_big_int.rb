class ChangeMarketCapToBigInt < ActiveRecord::Migration[5.0]
  def change
    change_column :historical_data, :market_cap, :bigint
  end
end

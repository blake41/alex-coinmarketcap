class CreateHistoricalData < ActiveRecord::Migration[5.0]
  def change
    create_table :historical_data do |t|
      t.integer :currency_id
      t.date :date
      t.float :open
      t.float :close
      t.float :high
      t.float :low
      t.bigint :volume
      t.integer :market_cap

      t.timestamps
    end
  end
end

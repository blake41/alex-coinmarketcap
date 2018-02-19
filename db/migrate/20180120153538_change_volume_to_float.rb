class ChangeVolumeToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :historical_data, :volume, :float
  end
end

class TempHalfHourlyEmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :temp_half_hourly_emissions do |t|
      t.string :trader
      t.float :emissions
      t.float :energy
      t.float :emissions_factor
      t.integer :month
      t.string :period

      t.timestamps
    end
  end
end

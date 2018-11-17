class CreateHalfHourlyEmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :half_hourly_emissions do |t|
      t.string :date
      t.integer :trading_period
      t.string :trader
      t.float :emissions
      t.float :energy
      t.float :emissions_factor

      t.timestamps
    end
  end
end

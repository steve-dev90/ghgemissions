class CreateAutomotiveFuelPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :automotive_fuel_prices do |t|
      t.integer :month
      t.string :fuel_type
      t.decimal :fuel_price

      t.timestamps
    end
  end
end

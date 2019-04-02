class RemoveClearedOffersTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :cleared_offers do |t|
      t.string :date
      t.integer :trading_period
      t.string :island
      t.string :poc
      t.string :trader
      t.string :offer_type
      t.float :cleared_energy
      t.float :emissions
      t.timestamps
    end
  end
end

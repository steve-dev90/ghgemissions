class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.integer :trading_period
      t.float :profile

      t.timestamps
    end
  end
end

class AddEmissionsToClearedOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :cleared_offers, :emissions, :float
  end
end

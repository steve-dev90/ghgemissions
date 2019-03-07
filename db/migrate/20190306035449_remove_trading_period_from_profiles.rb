class RemoveTradingPeriodFromProfiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :trading_period, :integer
    add_column :profiles, :period, :string
    add_column :profiles, :month, :integer
  end
end

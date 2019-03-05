class AddMonthToHalfHourlyEmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :half_hourly_emissions, :month, :integer
    rename_column :half_hourly_emissions, :trading_period, :period
  end
end

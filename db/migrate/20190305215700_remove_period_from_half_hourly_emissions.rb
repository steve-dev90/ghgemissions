class RemovePeriodFromHalfHourlyEmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :half_hourly_emissions, :period, :integer
    add_column :half_hourly_emissions, :period, :string
  end
end

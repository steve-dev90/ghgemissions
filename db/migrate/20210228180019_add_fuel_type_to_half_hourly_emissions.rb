class AddFuelTypeToHalfHourlyEmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :half_hourly_emissions, :fuel_type, :string
    remove_column :half_hourly_emissions, :trader, :string
  end
end

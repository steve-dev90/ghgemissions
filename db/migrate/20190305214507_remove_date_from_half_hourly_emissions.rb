class RemoveDateFromHalfHourlyEmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :half_hourly_emissions, :date, :string
  end
end

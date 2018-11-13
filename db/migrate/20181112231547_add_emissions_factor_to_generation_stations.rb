class AddEmissionsFactorToGenerationStations < ActiveRecord::Migration[5.2]
  def change
    add_column :generation_stations, :emissions_factor, :float
  end
end

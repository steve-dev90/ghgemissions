class CreateGenerationStations < ActiveRecord::Migration[5.2]
  def change
    create_table :generation_stations do |t|
      t.string :station_name
      t.string :poc
      t.string :generation_type
      t.string :fuel_name
      t.float :primary_efficiency

      t.timestamps
    end
  end
end

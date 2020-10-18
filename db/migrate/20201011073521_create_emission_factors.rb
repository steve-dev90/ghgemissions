class CreateEmissionFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :emission_factors do |t|
      t.string :fuel_type
      t.string :units
      t.decimal :factor

      t.timestamps
    end
  end
end

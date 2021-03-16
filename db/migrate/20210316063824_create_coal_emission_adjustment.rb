class CreateCoalEmissionAdjustment < ActiveRecord::Migration[6.0]
  def change
    create_table :coal_emission_adjustments do |t|
      t.integer :month
      t.float :adjust_factor

      t.timestamps
    end
  end
end

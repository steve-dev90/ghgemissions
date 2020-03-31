class CreateEnergyTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :energy_types do |t|
      t.string :name
    end
  end
end

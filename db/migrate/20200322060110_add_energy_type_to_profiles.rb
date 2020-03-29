class AddEnergyTypeToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :energy_type, :integer
  end
end

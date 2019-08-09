class CreateProcessedEmiFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :processed_emi_files do |t|
      t.string :file_name

      t.timestamps
    end
  end
end

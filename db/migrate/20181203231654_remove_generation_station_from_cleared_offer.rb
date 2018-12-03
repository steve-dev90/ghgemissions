class RemoveGenerationStationFromClearedOffer < ActiveRecord::Migration[5.2]
  def change
    remove_reference :cleared_offers, :generation_station, foreign_key: true
  end
end

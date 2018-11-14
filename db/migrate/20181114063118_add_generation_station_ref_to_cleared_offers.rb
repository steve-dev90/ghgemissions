class AddGenerationStationRefToClearedOffers < ActiveRecord::Migration[5.2]
  def change
    add_reference :cleared_offers, :generation_station, foreign_key: true
  end
end

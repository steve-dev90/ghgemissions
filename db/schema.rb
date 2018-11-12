# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_11_175451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cleared_offers", force: :cascade do |t|
    t.string "date"
    t.integer "trading_period"
    t.string "island"
    t.string "poc"
    t.string "trader"
    t.string "offer_type"
    t.float "cleared_energy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generation_stations", force: :cascade do |t|
    t.string "station_name"
    t.string "poc"
    t.string "generation_type"
    t.string "fuel_name"
    t.float "primary_efficiency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_02_063617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "automotive_fuel_prices", force: :cascade do |t|
    t.integer "month"
    t.string "fuel_type"
    t.decimal "fuel_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "energy_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "generation_stations", force: :cascade do |t|
    t.string "station_name"
    t.string "poc"
    t.string "generation_type"
    t.string "fuel_name"
    t.float "primary_efficiency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "emissions_factor"
  end

  create_table "half_hourly_emissions", force: :cascade do |t|
    t.string "trader"
    t.float "emissions"
    t.float "energy"
    t.float "emissions_factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "month"
    t.string "period"
  end

  create_table "processed_emi_files", force: :cascade do |t|
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.float "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "period"
    t.integer "month"
    t.integer "energy_type"
  end

  create_table "temp_half_hourly_emissions", force: :cascade do |t|
    t.string "trader"
    t.float "emissions"
    t.float "energy"
    t.float "emissions_factor"
    t.integer "month"
    t.string "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traders", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

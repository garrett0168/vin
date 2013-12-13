# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131211165228) do

  create_table "colors", force: true do |t|
    t.string "category"
    t.string "edmunds_id"
    t.string "name"
    t.string "availability"
    t.string "equipment_type"
  end

  create_table "colors_vehicles", id: false, force: true do |t|
    t.integer "color_id",   null: false
    t.integer "vehicle_id", null: false
  end

  add_index "colors_vehicles", ["color_id", "vehicle_id"], name: "index_colors_vehicles_on_color_id_and_vehicle_id", using: :btree
  add_index "colors_vehicles", ["vehicle_id", "color_id"], name: "index_colors_vehicles_on_vehicle_id_and_color_id", using: :btree

  create_table "options", force: true do |t|
    t.string "category"
    t.string "edmunds_id"
    t.string "name"
    t.string "description"
    t.string "availability"
    t.string "equipment_type"
  end

  create_table "options_vehicles", id: false, force: true do |t|
    t.integer "option_id",  null: false
    t.integer "vehicle_id", null: false
  end

  add_index "options_vehicles", ["option_id", "vehicle_id"], name: "index_options_vehicles_on_option_id_and_vehicle_id", using: :btree
  add_index "options_vehicles", ["vehicle_id", "option_id"], name: "index_options_vehicles_on_vehicle_id_and_option_id", using: :btree

  create_table "styles", force: true do |t|
    t.integer "vehicle_id"
    t.string  "edmunds_id"
    t.string  "name"
    t.string  "body"
    t.string  "model"
    t.string  "trim"
    t.integer "year"
  end

  create_table "vehicle_images", force: true do |t|
    t.string  "author_names"
    t.string  "caption"
    t.string  "image_type"
    t.string  "low_res_url"
    t.string  "medium_res_url"
    t.string  "high_res_url"
    t.integer "style_id"
  end

  create_table "vehicles", force: true do |t|
    t.string  "vin",                        null: false
    t.string  "make"
    t.string  "model"
    t.string  "transmission_type"
    t.string  "engine_type"
    t.integer "engine_cylinders"
    t.float   "engine_size"
    t.string  "driven_wheels"
    t.string  "manufacturer"
    t.string  "highway_mpg"
    t.string  "city_mpg"
    t.string  "category_epa"
    t.string  "category_primary_body_type"
    t.string  "category_vehicle_style"
    t.string  "category_vehicle_type"
  end

  add_index "vehicles", ["vin"], name: "index_vehicles_on_vin", using: :btree

end

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

ActiveRecord::Schema.define(version: 20131002204746) do

  create_table "vehicle_images", force: true do |t|
    t.integer "vehicle_id"
    t.string  "author_names"
    t.string  "caption"
    t.string  "image_type"
    t.string  "low_res_url"
    t.string  "medium_res_url"
    t.string  "high_res_url"
  end

  add_index "vehicle_images", ["vehicle_id"], name: "index_vehicle_images_on_vehicle_id", using: :btree

  create_table "vehicles", force: true do |t|
    t.string  "vin",               null: false
    t.string  "make"
    t.string  "model"
    t.integer "year"
    t.string  "transmission_type"
    t.string  "engine_type"
    t.integer "engine_cylinders"
    t.float   "engine_size"
    t.string  "trim"
    t.integer "style_id"
  end

  add_index "vehicles", ["vin"], name: "index_vehicles_on_vin", using: :btree

end

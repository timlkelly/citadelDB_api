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

ActiveRecord::Schema.define(version: 20160629161944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "citadels", force: :cascade do |t|
    t.string   "system"
    t.string   "nearest_celestial_y_s"
    t.string   "nearest_celestial_x_s"
    t.string   "nearest_celestial_z_s"
    t.string   "citadel_type"
    t.string   "corporation"
    t.string   "alliance"
    t.string   "killed_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "killmails", force: :cascade do |t|
    t.integer "citadel_id"
    t.integer "killmail_id"
    t.json    "killmail_json"
  end

end

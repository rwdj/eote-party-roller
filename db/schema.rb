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

ActiveRecord::Schema.define(version: 2019_06_17_205250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dice", force: :cascade do |t|
    t.string "name"
    t.jsonb "sides", default: []
    t.index ["name"], name: "index_dice_on_name"
    t.index ["sides"], name: "index_dice_on_sides", using: :gin
  end

  create_table "side_types", force: :cascade do |t|
    t.jsonb "results", default: {}
    t.string "md5_hash"
    t.index ["results"], name: "index_side_types_on_results", using: :gin
  end

end

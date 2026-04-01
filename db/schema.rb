# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_31_101500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "coffee_records", force: :cascade do |t|
    t.integer "acidity"
    t.integer "bean_amount", null: false
    t.string "bean_name", null: false
    t.integer "bitterness"
    t.integer "body"
    t.text "brew_memo"
    t.integer "brew_time", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "grind_size", null: false
    t.integer "off_flavor"
    t.integer "sweetness"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "water_amount", null: false
    t.integer "water_temperature", null: false
    t.index ["user_id"], name: "index_coffee_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "coffee_records", "users"
end

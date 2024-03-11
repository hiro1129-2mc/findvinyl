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

ActiveRecord::Schema[7.1].define(version: 2024_03_10_160730) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artist_credit_names", force: :cascade do |t|
    t.bigint "artist_credit_id", null: false
    t.bigint "artist_id", null: false
    t.index ["artist_credit_id"], name: "index_artist_credit_names_on_artist_credit_id"
    t.index ["artist_id"], name: "index_artist_credit_names_on_artist_id"
  end

  create_table "artist_credits", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.uuid "gid", null: false
    t.string "name", null: false
    t.index ["name"], name: "index_artists_on_name"
  end

  create_table "medium_formats", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "mediums", force: :cascade do |t|
    t.bigint "release_id", null: false
    t.bigint "medium_format_id"
    t.index ["medium_format_id"], name: "index_mediums_on_medium_format_id"
    t.index ["release_id"], name: "index_mediums_on_release_id"
  end

  create_table "releases", force: :cascade do |t|
    t.uuid "gid", null: false
    t.string "name", null: false
    t.bigint "artist_credit_id", null: false
    t.index ["artist_credit_id"], name: "index_releases_on_artist_credit_id"
    t.index ["name"], name: "index_releases_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "profile_image"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "artist_credit_names", "artist_credits"
  add_foreign_key "artist_credit_names", "artists"
  add_foreign_key "mediums", "medium_formats"
  add_foreign_key "mediums", "releases"
  add_foreign_key "releases", "artist_credits"
end

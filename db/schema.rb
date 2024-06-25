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

ActiveRecord::Schema[7.1].define(version: 2024_06_25_125311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessories", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_accessories_on_name", unique: true
  end

  create_table "artist_credit_names", force: :cascade do |t|
    t.bigint "artist_credit_id", null: false
    t.bigint "artist_id", null: false
    t.index ["artist_credit_id"], name: "index_artist_credit_names_on_artist_credit_id"
    t.index ["artist_id"], name: "index_artist_credit_names_on_artist_id"
  end

  create_table "artist_credits", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "artist_names", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_artist_names_on_name", unique: true
  end

  create_table "artists", force: :cascade do |t|
    t.uuid "gid", null: false
    t.string "name", null: false
    t.index ["name"], name: "index_artists_on_name"
  end

  create_table "conditions", force: :cascade do |t|
    t.string "grade", null: false
    t.index ["grade"], name: "index_conditions_on_grade", unique: true
  end

  create_table "item_accessories", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "accessory_id", null: false
    t.index ["accessory_id"], name: "index_item_accessories_on_accessory_id"
    t.index ["item_id", "accessory_id"], name: "index_item_accessories_on_item_id_and_accessory_id", unique: true
    t.index ["item_id"], name: "index_item_accessories_on_item_id"
  end

  create_table "item_tags", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "tag_id", null: false
    t.index ["item_id", "tag_id"], name: "index_item_tags_on_item_id_and_tag_id", unique: true
    t.index ["item_id"], name: "index_item_tags_on_item_id"
    t.index ["tag_id"], name: "index_item_tags_on_tag_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "title_id", null: false
    t.bigint "artist_name_id", null: false
    t.bigint "press_country_id"
    t.bigint "matrix_number_id"
    t.bigint "condition_id"
    t.text "user_note"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "release_format_id"
    t.integer "status", default: 0, null: false
    t.index ["artist_name_id"], name: "index_items_on_artist_name_id"
    t.index ["condition_id"], name: "index_items_on_condition_id"
    t.index ["matrix_number_id"], name: "index_items_on_matrix_number_id"
    t.index ["press_country_id"], name: "index_items_on_press_country_id"
    t.index ["release_format_id"], name: "index_items_on_release_format_id"
    t.index ["title_id"], name: "index_items_on_title_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "matrix_numbers", force: :cascade do |t|
    t.string "number", null: false
    t.index ["number"], name: "index_matrix_numbers_on_number", unique: true
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

  create_table "press_countries", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_press_countries_on_name", unique: true
  end

  create_table "record_items", force: :cascade do |t|
    t.bigint "record_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_record_items_on_item_id"
    t.index ["record_id"], name: "index_record_items_on_record_id"
  end

  create_table "records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "release_formats", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "releases", force: :cascade do |t|
    t.uuid "gid", null: false
    t.string "name", null: false
    t.bigint "artist_credit_id", null: false
    t.index ["artist_credit_id"], name: "index_releases_on_artist_credit_id"
    t.index ["name"], name: "index_releases_on_name"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.string "postal_code"
    t.string "address"
    t.string "phone_number"
    t.string "opening_hours"
    t.string "web_site"
    t.string "shop_image"
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.string "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "titles", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_titles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "new_email"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "artist_credit_names", "artist_credits"
  add_foreign_key "artist_credit_names", "artists"
  add_foreign_key "item_accessories", "accessories"
  add_foreign_key "item_accessories", "items"
  add_foreign_key "item_tags", "items"
  add_foreign_key "item_tags", "tags"
  add_foreign_key "items", "artist_names"
  add_foreign_key "items", "conditions"
  add_foreign_key "items", "matrix_numbers"
  add_foreign_key "items", "press_countries"
  add_foreign_key "items", "release_formats"
  add_foreign_key "items", "titles"
  add_foreign_key "items", "users"
  add_foreign_key "mediums", "medium_formats"
  add_foreign_key "mediums", "releases"
  add_foreign_key "record_items", "items"
  add_foreign_key "record_items", "records"
  add_foreign_key "records", "users"
  add_foreign_key "releases", "artist_credits"
end

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

ActiveRecord::Schema.define(version: 2021_10_31_201728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_course_associations", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id", "course_id"], name: "index_book_course_associations_on_book_id_and_course_id", unique: true
    t.index ["book_id"], name: "index_book_course_associations_on_book_id"
    t.index ["course_id"], name: "index_book_course_associations_on_course_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "authors"
    t.string "edition"
    t.string "publisher"
    t.string "isbn"
    t.string "photo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "code"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "listing_bookmarks", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_listing_bookmarks_on_listing_id"
    t.index ["user_id"], name: "index_listing_bookmarks_on_user_id"
  end

  create_table "listing_contacts", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.datetime "contact_timestamp"
    t.bigint "initiator_id", null: false
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["initiator_id"], name: "index_listing_contacts_on_initiator_id"
    t.index ["listing_id"], name: "index_listing_contacts_on_listing_id"
  end

  create_table "listing_images", force: :cascade do |t|
    t.string "image_url"
    t.bigint "listing_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_listing_images_on_listing_id"
  end

  create_table "listings", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.float "price", null: false
    t.string "condition"
    t.text "description"
    t.bigint "seller_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_listings_on_book_id"
    t.index ["seller_id"], name: "index_listings_on_seller_id"
  end

  create_table "user_reputation_ratings", force: :cascade do |t|
    t.bigint "target_user_id", null: false
    t.bigint "rater_user_id", null: false
    t.bigint "listing_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listing_id"], name: "index_user_reputation_ratings_on_listing_id"
    t.index ["rater_user_id"], name: "index_user_reputation_ratings_on_rater_user_id"
    t.index ["target_user_id"], name: "index_user_reputation_ratings_on_target_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "uni"
    t.string "email", null: false
    t.string "school"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "book_course_associations", "books"
  add_foreign_key "book_course_associations", "courses"
  add_foreign_key "listing_bookmarks", "listings"
  add_foreign_key "listing_bookmarks", "users"
  add_foreign_key "listing_contacts", "listings"
  add_foreign_key "listing_contacts", "users", column: "initiator_id"
  add_foreign_key "listing_images", "listings"
  add_foreign_key "listings", "books"
  add_foreign_key "listings", "users", column: "seller_id"
  add_foreign_key "user_reputation_ratings", "listings"
  add_foreign_key "user_reputation_ratings", "users", column: "rater_user_id"
  add_foreign_key "user_reputation_ratings", "users", column: "target_user_id"
end

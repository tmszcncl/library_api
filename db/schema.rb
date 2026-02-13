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

ActiveRecord::Schema[8.1].define(version: 2026_02_13_213007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.string "serial_number"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["serial_number"], name: "index_books_on_serial_number", unique: true
  end

  create_table "borrowings", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "borrowed_at"
    t.datetime "created_at", null: false
    t.bigint "reader_id", null: false
    t.datetime "returned_at"
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_borrowings_on_book_id"
    t.index ["reader_id"], name: "index_borrowings_on_reader_id"
  end

  create_table "readers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "library_card_number"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_readers_on_email", unique: true
    t.index ["library_card_number"], name: "index_readers_on_library_card_number", unique: true
  end

  add_foreign_key "borrowings", "books"
  add_foreign_key "borrowings", "readers"
end

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

ActiveRecord::Schema[7.0].define(version: 2023_09_21_112225) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "escrow_accounts", force: :cascade do |t|
    t.decimal "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "held_funds", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_held_funds_on_user_id"
  end

  create_table "pending_seller_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "opposite_user_id", null: false
    t.bigint "escrow_account_id"
    t.decimal "amount"
    t.integer "status", default: 0
    t.integer "buyer_confirmation", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escrow_account_id"], name: "index_pending_seller_transactions_on_escrow_account_id"
    t.index ["opposite_user_id"], name: "index_pending_seller_transactions_on_opposite_user_id"
    t.index ["user_id"], name: "index_pending_seller_transactions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "opposite_user_id", null: false
    t.bigint "escrow_account_id"
    t.decimal "amount"
    t.integer "status", default: 0, null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escrow_account_id"], name: "index_transactions_on_escrow_account_id"
    t.index ["opposite_user_id"], name: "index_transactions_on_opposite_user_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstName"
    t.string "middleName"
    t.string "surname"
    t.string "email"
    t.string "password_digest"
    t.text "address"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified"
    t.string "verification_code"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "held_funds", "users"
  add_foreign_key "pending_seller_transactions", "escrow_accounts"
  add_foreign_key "pending_seller_transactions", "users"
  add_foreign_key "pending_seller_transactions", "users", column: "opposite_user_id"
  add_foreign_key "transactions", "escrow_accounts"
  add_foreign_key "transactions", "users"
  add_foreign_key "transactions", "users", column: "opposite_user_id"
end

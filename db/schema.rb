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

ActiveRecord::Schema.define(version: 20140516115139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buy_entries", force: true do |t|
    t.integer "buy_id",                 null: false
    t.integer "product_id",             null: false
    t.integer "amount",     default: 1
  end

  add_index "buy_entries", ["buy_id"], name: "index_buy_entries_on_buy_id", using: :btree

  create_table "buys", force: true do |t|
    t.integer  "buyer_id",                                         null: false
    t.decimal  "price",      precision: 6, scale: 2, default: 0.0, null: false
    t.datetime "created_at"
  end

  add_index "buys", ["buyer_id"], name: "index_buys_on_buyer_id", using: :btree
  add_index "buys", ["created_at"], name: "index_buys_on_created_at", using: :btree

  create_table "changes", force: true do |t|
    t.integer  "trackable_id",   null: false
    t.string   "trackable_type", null: false
    t.integer  "doer_id"
    t.json     "change"
    t.text     "change_note"
    t.string   "type"
    t.datetime "created_at"
  end

  add_index "changes", ["doer_id", "trackable_id"], name: "index_changes_on_doer_id_and_trackable_id", using: :btree
  add_index "changes", ["trackable_type", "trackable_id"], name: "index_changes_on_trackable_type_and_trackable_id", using: :btree

  create_table "product_entries", force: true do |t|
    t.integer  "amount",     default: 0
    t.integer  "product_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_entries", ["product_id"], name: "index_product_entries_on_product_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name",                                                 null: false
    t.text     "description"
    t.decimal  "price",          precision: 6, scale: 2, default: 0.0, null: false
    t.integer  "stock",                                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "buy_count",                              default: 0
    t.datetime "last_bought_at"
  end

  add_index "products", ["name"], name: "index_products_on_name", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                          default: "",    null: false
    t.string   "encrypted_password",                             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                                default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "username"
    t.decimal  "balance",                precision: 6, scale: 2, default: 0.0,   null: false
    t.integer  "buy_count",                                      default: 0
    t.boolean  "admin",                                          default: false
    t.boolean  "staff",                                          default: false
    t.datetime "time_of_last_buy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bit_flags"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_04_014922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.integer "transaction_type"
    t.decimal "price", precision: 8, scale: 2
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_orders_on_stock_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker"
    t.string "company_name"
    t.decimal "price", precision: 8, scale: 2
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_name"], name: "index_stocks_on_company_name", unique: true
    t.index ["ticker"], name: "index_stocks_on_ticker", unique: true
  end

  create_table "transaction_records", force: :cascade do |t|
    t.bigint "stock_id"
    t.bigint "buyer_id", null: false
    t.bigint "broker_id", null: false
    t.integer "transaction_type"
    t.decimal "price", precision: 8, scale: 2
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["broker_id"], name: "index_transaction_records_on_broker_id"
    t.index ["buyer_id"], name: "index_transaction_records_on_buyer_id"
    t.index ["stock_id"], name: "index_transaction_records_on_stock_id"
  end

  create_table "user_stocks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.decimal "average_price", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_user_stocks_on_stock_id"
    t.index ["user_id"], name: "index_user_stocks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role", default: "buyer"
    t.string "username"
    t.string "firstname"
    t.string "lastname"
    t.decimal "balance", precision: 8, scale: 2, default: "5000.0"
    t.integer "broker_status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["broker_status"], name: "index_users_on_broker_status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

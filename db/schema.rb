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

ActiveRecord::Schema.define(version: 20180109153652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "cnpj"
    t.integer "available_funds_cents", default: 0, null: false
    t.string "available_funds_currency", default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "installments", force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "number"
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "BRL", null: false
    t.datetime "due_date"
    t.integer "outstanding_days"
    t.integer "interest_cents", default: 0, null: false
    t.string "interest_currency", default: "BRL", null: false
    t.integer "ad_valorem_cents", default: 0, null: false
    t.string "ad_valorem_currency", default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_installments_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "type"
    t.string "invoice_number"
    t.string "contract_number"
    t.string "check_number"
    t.string "status"
    t.string "delivery_status"
    t.boolean "confirmed"
    t.boolean "notified"
    t.boolean "boleto_especial"
    t.integer "average_outstanding_days"
    t.integer "total_value_cents", default: 0, null: false
    t.string "total_value_currency", default: "BRL", null: false
    t.integer "average_interest_cents", default: 0, null: false
    t.string "average_interest_currency", default: "BRL", null: false
    t.integer "average_ad_valorem_cents", default: 0, null: false
    t.string "average_ad_valorem_currency", default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", force: :cascade do |t|
    t.integer "total_value_cents", default: 0, null: false
    t.string "total_value_currency", default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rebuys", force: :cascade do |t|
    t.bigint "operation_id"
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_rebuys_on_invoice_id"
    t.index ["operation_id"], name: "index_rebuys_on_operation_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "identification_number"
    t.string "company_name"
    t.string "company_nickname"
    t.string "business_entity"
    t.string "registration_number"
    t.string "nire"
    t.datetime "incorporation_date"
    t.string "zip_code"
    t.string "address"
    t.string "address_number"
    t.string "neighborhood"
    t.string "address_2"
    t.string "state"
    t.string "city"
    t.string "corporate_capital"
    t.string "activity"
    t.string "cnae"
    t.string "tax_option"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_sellers_on_client_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "installments", "invoices"
  add_foreign_key "rebuys", "invoices"
  add_foreign_key "rebuys", "operations"
  add_foreign_key "sellers", "clients"
end

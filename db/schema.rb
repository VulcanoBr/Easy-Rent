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

ActiveRecord::Schema[7.1].define(version: 2024_07_12_234145) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.string "email"
    t.string "mobile_phone"
    t.string "address"
    t.string "identification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_customers_on_email"
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "equipaments", force: :cascade do |t|
    t.string "name", null: false
    t.string "serial_number", null: false
    t.string "status", limit: 20, default: "available"
    t.decimal "rent_value", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serial_number"], name: "index_equipaments_on_serial_number", unique: true
  end

  create_table "maintenances", force: :cascade do |t|
    t.bigint "equipament_id", null: false
    t.string "maintenance_type"
    t.date "period_start"
    t.date "period_end"
    t.decimal "maintenance_value", precision: 10, scale: 2
    t.string "status", limit: 20, default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipament_id"], name: "index_maintenances_on_equipament_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "equipament_id", null: false
    t.string "order_code"
    t.date "period_start", null: false
    t.date "period_end"
    t.string "status", limit: 20, default: "pending"
    t.decimal "rent_value", precision: 10, scale: 2
    t.decimal "tot_rent_value", precision: 10, scale: 2
    t.string "payment_method"
    t.integer "installments"
    t.string "pix_code"
    t.string "ticket_barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["equipament_id"], name: "index_orders_on_equipament_id"
    t.index ["status"], name: "index_orders_on_status"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "equipament_id", null: false
    t.string "status", limit: 20, default: "pending"
    t.date "period_start", null: false
    t.date "period_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipament_id"], name: "index_schedules_on_equipament_id"
    t.index ["order_id"], name: "index_schedules_on_order_id"
    t.index ["status"], name: "index_schedules_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", limit: 20
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "maintenances", "equipaments"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "equipaments"
  add_foreign_key "schedules", "equipaments"
  add_foreign_key "schedules", "orders"
end

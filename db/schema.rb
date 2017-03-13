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

ActiveRecord::Schema.define(version: 20170312222255) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "request_id"
    t.integer "user_id"
    t.boolean "customer"
    t.boolean "assigned"
    t.boolean "creator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_files", force: :cascade do |t|
    t.integer "request_id"
    t.string "attachment_uploader", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by", limit: 255
    t.string "queue", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "modellings", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "name", limit: 255
    t.text     "description"
    t.string "attachment", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status", limit: 255, default: "Pending"
    t.string "assignment", limit: 255
    t.text     "result"
    t.string "stathist", limit: 255
    t.string "customer", limit: 255
    t.string "priority", limit: 255
    t.integer  "esthours"
    t.integer  "tothours"
    t.text "current_changes"
  end

  create_table "result_files", force: :cascade do |t|
    t.integer  "request_id"
    t.string "attachment_uploader", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.boolean  "manager"
    t.string "group", limit: 255
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end

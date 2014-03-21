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

ActiveRecord::Schema.define(version: 20140319101821) do

  create_table "activities", force: true do |t|
    t.integer  "group_id"
    t.string   "title"
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.datetime "applied_at"
    t.integer  "number_limit"
    t.string   "pay_type"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "location"
    t.string   "approval"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["group_id"], name: "index_activities_on_group_id"

  create_table "card_types", force: true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.decimal  "price"
    t.integer  "duration"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "card_types", ["group_id"], name: "index_card_types_on_group_id"

  create_table "cards", force: true do |t|
    t.integer  "user_id"
    t.integer  "card_type_id"
    t.date     "started_at"
    t.date     "stopped_at"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["card_type_id"], name: "index_cards_on_card_type_id"
  add_index "cards", ["user_id"], name: "index_cards_on_user_id"

  create_table "cities", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "province_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debits", force: true do |t|
    t.decimal  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "city_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_items", force: true do |t|
    t.integer  "activity_id"
    t.integer  "fee_id"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fee_items", ["activity_id"], name: "index_fee_items_on_activity_id"
  add_index "fee_items", ["fee_id"], name: "index_fee_items_on_fee_id"

  create_table "fees", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fees", ["group_id"], name: "index_fees_on_group_id"
  add_index "fees", ["user_id"], name: "index_fees_on_user_id"

  create_table "groups", force: true do |t|
    t.string   "uniqname"
    t.string   "name"
    t.string   "pay_type"
    t.decimal  "price"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "location"
    t.text     "aboutme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true
  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id"
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id"

  create_table "participants", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.integer  "friend_number"
    t.decimal  "derated_pay"
    t.decimal  "net_pay"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["activity_id"], name: "index_participants_on_activity_id"
  add_index "participants", ["user_id"], name: "index_participants_on_user_id"

  create_table "provinces", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.decimal  "amount"
    t.datetime "operated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "name"
    t.date     "birthday"
    t.string   "gender"
    t.string   "mobile"
    t.string   "telephone"
    t.string   "gravatar"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "location"
    t.text     "aboutme"
    t.integer  "debit_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end

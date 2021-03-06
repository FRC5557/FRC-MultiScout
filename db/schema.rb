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

ActiveRecord::Schema.define(version: 20170228163829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "key",        null: false
    t.string   "name",       null: false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_events_on_key", unique: true, using: :btree
  end

  create_table "match_data", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "competition_stage", null: false
    t.integer  "set_number",        null: false
    t.integer  "match_number",      null: false
    t.integer  "team_number",       null: false
    t.string   "station"
    t.string   "match_time"
    t.text     "data"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["event_id"], name: "index_match_data_on_event_id", using: :btree
    t.index ["team_id"], name: "index_match_data_on_team_id", using: :btree
    t.index ["user_id"], name: "index_match_data_on_user_id", using: :btree
  end

  create_table "pit_data", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "number",     null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_pit_data_on_event_id", using: :btree
    t.index ["number"], name: "index_pit_data_on_number", unique: true, using: :btree
    t.index ["team_id"], name: "index_pit_data_on_team_id", using: :btree
    t.index ["user_id"], name: "index_pit_data_on_user_id", using: :btree
  end

  create_table "scout_schemas", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "pit_data",                    null: false
    t.text     "match_data",                  null: false
    t.boolean  "is_official", default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["name"], name: "index_scout_schemas_on_name", unique: true, using: :btree
  end

  create_table "team_registrations", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.boolean  "denied",       default: false
    t.datetime "confirmed_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["team_id"], name: "index_team_registrations_on_team_id", using: :btree
    t.index ["user_id"], name: "index_team_registrations_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "number",            null: false
    t.string   "name"
    t.integer  "scout_schema_id"
    t.integer  "event_id"
    t.string   "scout_assignments"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["event_id"], name: "index_teams_on_event_id", using: :btree
    t.index ["scout_schema_id"], name: "index_teams_on_scout_schema_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                             null: false
    t.string   "last_name",                              null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "is_team_manager",        default: false, null: false
    t.boolean  "is_administrator",       default: false, null: false
    t.boolean  "is_checked_in",          default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end

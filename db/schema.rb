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

ActiveRecord::Schema.define(version: 20170604152437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "affiliations", force: :cascade do |t|
    t.uuid     "user_id",         null: false
    t.uuid     "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_affiliations_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_affiliations_on_user_id", using: :btree
  end

  create_table "organizations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string    "name",                                                                             default: "", null: false
    t.string    "desc",                                                                             default: "", null: false
    t.json      "social"
    t.integer   "teaching_range_start",                                                             default: 0,  null: false
    t.integer   "teaching_range_end",                                                               default: 0,  null: false
    t.string    "address_line1"
    t.string    "address_line2"
    t.string    "address_line3"
    t.string    "address_line4"
    t.string    "locality"
    t.string    "region"
    t.string    "post_code"
    t.string    "country"
    t.geography "lonlat",               limit: {:srid=>4326, :type=>"st_point", :geographic=>true},              null: false
    t.datetime  "created_at",                                                                                    null: false
    t.datetime  "updated_at",                                                                                    null: false
    t.index ["lonlat"], name: "index_organizations_on_lonlat", using: :btree
    t.index ["name"], name: "index_organizations_on_name", using: :btree
    t.index ["post_code"], name: "index_organizations_on_post_code", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name",                   default: "", null: false
    t.integer  "role",                   default: 0,  null: false
    t.string   "avatar_url"
    t.string   "bio",                    default: "", null: false
    t.integer  "kind",                   default: 0,  null: false
    t.string   "phone_number"
    t.json     "social"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  end

  add_foreign_key "affiliations", "organizations"
  add_foreign_key "affiliations", "users"
end

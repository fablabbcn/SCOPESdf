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

ActiveRecord::Schema.define(version: 20171209151747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "affiliations", force: :cascade do |t|
    t.uuid     "user_id",                         null: false
    t.uuid     "organization_id",                 null: false
    t.boolean  "primary",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["organization_id"], name: "index_affiliations_on_organization_id", using: :btree
    t.index ["primary"], name: "index_affiliations_on_primary", using: :btree
    t.index ["user_id"], name: "index_affiliations_on_user_id", using: :btree
  end

  create_table "collection_tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name",        null: false
    t.string "description", null: false
    t.index ["name"], name: "index_collection_tags_on_name", using: :btree
  end

  create_table "contexts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_contexts_on_name", using: :btree
  end

  create_table "generic_tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_generic_tags_on_name", using: :btree
  end

  create_table "invited_users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",        null: false
    t.json     "data"
    t.string   "name"
    t.string   "invite_link",  null: false
    t.datetime "confirmed_at"
    t.datetime "created_at",   null: false
    t.index ["email"], name: "index_invited_users_on_email", using: :btree
    t.index ["invite_link"], name: "index_invited_users_on_invite_link", using: :btree
    t.index ["name"], name: "index_invited_users_on_name", using: :btree
  end

  create_table "involvements", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_involvements_on_name", using: :btree
  end

  create_table "lesson_tags", force: :cascade do |t|
    t.uuid     "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.uuid     "lesson_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["lesson_id"], name: "index_lesson_tags_on_lesson_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_lesson_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "lessons", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",                      default: "", null: false
    t.string   "topline",                   default: "", null: false
    t.string   "summary",                   default: "", null: false
    t.string   "learning_objectives",                                 array: true
    t.string   "teacher_notes",             default: "", null: false
    t.string   "assessment_criteria",       default: "", null: false
    t.string   "assessment_criteria_files", default: [],              array: true
    t.string   "further_readings",                                    array: true
    t.json     "standards"
    t.string   "outcome_files",             default: [],              array: true
    t.uuid     "original_lesson"
    t.integer  "state",                     default: 1,  null: false
    t.datetime "published_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "key_concepts",              default: [],              array: true
    t.string   "key_vocabularies",          default: [],              array: true
    t.string   "key_formulas",              default: [],              array: true
    t.string   "fabrication_tools",         default: [],              array: true
    t.string   "duration"
    t.index ["name"], name: "index_lessons_on_name", using: :btree
    t.index ["original_lesson"], name: "index_lessons_on_original_lesson", using: :btree
    t.index ["state"], name: "index_lessons_on_state", using: :btree
  end

  create_table "lessons_standards", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid    "lesson_id",   null: false
    t.uuid    "standard_id", null: false
    t.string  "description"
    t.integer "index"
    t.index ["lesson_id"], name: "index_lessons_standards_on_lesson_id", using: :btree
    t.index ["standard_id"], name: "index_lessons_standards_on_standard_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.uuid     "lesson_id",  null: false
    t.uuid     "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_likes_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "mastery_levels", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "level",  default: 0, null: false
    t.integer "metric", default: 0, null: false
    t.index ["level"], name: "index_mastery_levels_on_level", using: :btree
    t.index ["metric"], name: "index_mastery_levels_on_metric", using: :btree
  end

  create_table "org_tags", force: :cascade do |t|
    t.uuid     "taggable_id",     null: false
    t.string   "taggable_type",   null: false
    t.uuid     "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_org_tags_on_organization_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_org_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "organizations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string    "name",                                                                      default: "", null: false
    t.string    "desc",                                                                      default: "", null: false
    t.json      "social"
    t.string    "contact_email"
    t.integer   "state",                                                                     default: 0,  null: false
    t.string    "address_line1"
    t.string    "address_line2"
    t.string    "address_line3"
    t.string    "address_line4"
    t.string    "locality"
    t.string    "region"
    t.string    "post_code"
    t.string    "country"
    t.geography "lonlat",        limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime  "created_at",                                                                             null: false
    t.datetime  "updated_at",                                                                             null: false
    t.index ["contact_email"], name: "index_organizations_on_contact_email", using: :btree
    t.index ["lonlat"], name: "index_organizations_on_lonlat", using: :btree
    t.index ["name"], name: "index_organizations_on_name", using: :btree
    t.index ["post_code"], name: "index_organizations_on_post_code", using: :btree
    t.index ["state"], name: "index_organizations_on_state", using: :btree
  end

  create_table "other_interests", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_other_interests_on_name", using: :btree
  end

  create_table "skill_tags", force: :cascade do |t|
    t.uuid    "taggable_id",               null: false
    t.string  "taggable_type",             null: false
    t.integer "skill_id",                  null: false
    t.integer "level",         default: 0, null: false
    t.index ["level"], name: "index_skill_tags_on_level", using: :btree
    t.index ["skill_id"], name: "index_skill_tags_on_skill_id", using: :btree
    t.index ["taggable_type", "taggable_id"], name: "index_skill_tags_on_taggable_type_and_taggable_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_skills_on_name", using: :btree
  end

  create_table "standards", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name",         null: false
    t.string "autocomplete"
    t.index ["name"], name: "index_standards_on_name", using: :btree
  end

  create_table "steps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "lesson_id",                          null: false
    t.string   "summary",                            null: false
    t.integer  "duration",              default: 0,  null: false
    t.string   "description",           default: "", null: false
    t.string   "images",                default: [],              array: true
    t.string   "tools",                                           array: true
    t.string   "design_files",          default: [],              array: true
    t.string   "external_links",                                  array: true
    t.integer  "step_number",                        null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "software",              default: [],              array: true
    t.string   "fabrication_equipment", default: [],              array: true
    t.string   "name"
    t.string   "materials",             default: [],              array: true
    t.index ["lesson_id"], name: "index_steps_on_lesson_id", using: :btree
  end

  create_table "subjects", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_subjects_on_name", using: :btree
  end

  create_table "teaching_ranges", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "range_start", default: 0, null: false
    t.integer "range_end",   default: 0, null: false
  end

  create_table "user_tags", force: :cascade do |t|
    t.uuid     "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.uuid     "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["taggable_type", "taggable_id"], name: "index_user_tags_on_taggable_type_and_taggable_id", using: :btree
    t.index ["user_id"], name: "index_user_tags_on_user_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string    "email",                                                                              default: "", null: false
    t.string    "encrypted_password",                                                                 default: "", null: false
    t.string    "reset_password_token"
    t.datetime  "reset_password_sent_at"
    t.datetime  "remember_created_at"
    t.integer   "sign_in_count",                                                                      default: 0,  null: false
    t.datetime  "current_sign_in_at"
    t.datetime  "last_sign_in_at"
    t.inet      "current_sign_in_ip"
    t.inet      "last_sign_in_ip"
    t.integer   "role",                                                                               default: 0,  null: false
    t.string    "name",                                                                               default: "", null: false
    t.string    "avatar",                                                                             default: ""
    t.string    "address_line1"
    t.string    "address_line2"
    t.string    "address_line3"
    t.string    "address_line4"
    t.string    "locality"
    t.string    "region"
    t.string    "post_code"
    t.string    "country"
    t.geography "lonlat",                 limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string    "bio",                                                                                default: "", null: false
    t.json      "social"
    t.json      "settings",                                                                                        null: false
    t.datetime  "created_at",                                                                                      null: false
    t.datetime  "updated_at",                                                                                      null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["lonlat"], name: "index_users_on_lonlat", using: :btree
    t.index ["post_code"], name: "index_users_on_post_code", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  end

  add_foreign_key "affiliations", "organizations"
  add_foreign_key "affiliations", "users"
  add_foreign_key "lesson_tags", "lessons"
  add_foreign_key "lessons_standards", "lessons"
  add_foreign_key "lessons_standards", "standards"
  add_foreign_key "likes", "lessons"
  add_foreign_key "likes", "users"
  add_foreign_key "org_tags", "organizations"
  add_foreign_key "skill_tags", "skills"
  add_foreign_key "steps", "lessons"
  add_foreign_key "user_tags", "users"
end

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

ActiveRecord::Schema[7.2].define(version: 2025_12_09_111507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guardian_notifications", force: :cascade do |t|
    t.bigint "run_id", null: false
    t.bigint "guardian_id", null: false
    t.float "longitude"
    t.float "latitude"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guardian_id"], name: "index_guardian_notifications_on_guardian_id"
    t.index ["run_id"], name: "index_guardian_notifications_on_run_id"
  end

  create_table "guardians", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_guardians_on_user_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.string "incident_detail"
    t.bigint "run_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id"], name: "index_incidents_on_run_id"
  end

  create_table "positions", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.float "distance_from_last"
    t.bigint "run_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id"], name: "index_positions_on_run_id"
  end

  create_table "run_badges", force: :cascade do |t|
    t.bigint "run_id", null: false
    t.bigint "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_run_badges_on_badge_id"
    t.index ["run_id"], name: "index_run_badges_on_run_id"
  end

  create_table "runs", force: :cascade do |t|
    t.integer "duration"
    t.float "distance"
    t.string "status"
    t.string "start_point"
    t.float "start_point_lat"
    t.float "start_point_lng"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_runs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "guardian_notifications", "guardians"
  add_foreign_key "guardian_notifications", "runs"
  add_foreign_key "guardians", "users"
  add_foreign_key "incidents", "runs"
  add_foreign_key "positions", "runs"
  add_foreign_key "run_badges", "badges"
  add_foreign_key "run_badges", "runs"
  add_foreign_key "runs", "users"
end

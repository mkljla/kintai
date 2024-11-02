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

ActiveRecord::Schema[7.1].define(version: 2024_10_31_153036) do
  create_table "breaks", force: :cascade do |t|
    t.integer "work_id", null: false
    t.datetime "break_start_datetime"
    t.datetime "break_end_datetime"
    t.integer "total_break_time_in_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id"], name: "index_breaks_on_work_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sort_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_work_hour_settings", force: :cascade do |t|
    t.integer "standard_working_time_minutes"
    t.date "applicable_start_date"
    t.date "applicable_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "employee_number", null: false
    t.string "full_name", null: false
    t.date "date_of_hire", null: false
    t.date "date_of_termination"
    t.string "password_digest", null: false
    t.integer "department_id"
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  create_table "works", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "start_datetime", precision: nil
    t.datetime "end_datetime", precision: nil
    t.integer "total_working_time_in_minutes"
    t.integer "total_overtime_in_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "breaks", "works"
  add_foreign_key "users", "departments"
  add_foreign_key "works", "users"
end

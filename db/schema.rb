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
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "breaks", force: :cascade do |t|
    t.bigint "work_id", null: false, comment: "Work ID"
    t.datetime "start_datetime", comment: "休憩開始時間"
    t.datetime "end_datetime", comment: "休憩終了時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id"], name: "index_breaks_on_work_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false, comment: "部門名"
    t.integer "sort_no", comment: "表示順"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "m_work_hour_settings", force: :cascade do |t|
    t.integer "standard_working_time_minutes", comment: "基本労働時間"
    t.date "applicable_start_date", comment: "適用開始日"
    t.date "applicable_end_date", comment: "適用終了日"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "employee_number", null: false, comment: "社員番号"
    t.string "full_name", null: false, comment: "フルネーム"
    t.date "date_of_hire", null: false, comment: "入社日"
    t.date "date_of_termination", comment: "退職日"
    t.string "password_digest", null: false, comment: "パスワード（ハッシュ）"
    t.bigint "department_id", comment: "部門ID"
    t.boolean "is_admin", default: false, null: false, comment: "管理者フラグ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  create_table "works", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.datetime "start_datetime", precision: nil, comment: "出勤時間"
    t.datetime "end_datetime", precision: nil, comment: "退勤時間"
    t.integer "total_working_time_in_minutes", comment: "労働時間の合計"
    t.integer "total_overtime_in_minutes", comment: "残業時間の合計"
    t.integer "total_break_time_in_minutes", comment: "休憩時間の合計"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "breaks", "works"
  add_foreign_key "users", "departments"
  add_foreign_key "works", "users"
end

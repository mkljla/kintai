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
    t.bigint "work_id", null: false, comment: "勤務ID"
    t.datetime "start_datetime", null: false, comment: "休憩開始時間"
    t.datetime "end_datetime", comment: "休憩終了時間"
    t.integer "break_time_in_minutes", default: 0, comment: "休憩時間(分)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id"], name: "index_breaks_on_work_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", limit: 50, null: false, comment: "会社名"
    t.integer "default_work_hours", null: false, comment: "基本労働時間"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "full_name", comment: "フルネーム"
    t.string "family_name", limit: 20, null: false, comment: "姓"
    t.string "first_name", limit: 20, null: false, comment: "名"
    t.string "family_name_kana", limit: 30, null: false, comment: "姓(かな)"
    t.string "first_name_kana", limit: 30, null: false, comment: "名(かな)"
    t.string "full_name_kana", comment: "フルネーム(かな)"
    t.date "birthday", null: false, comment: "生年月日"
    t.date "date_of_hire", null: false, comment: "入社日"
    t.date "date_of_termination", comment: "退職日"
    t.string "password_digest", null: false, comment: "パスワード（ハッシュ）"
    t.bigint "department_id", comment: "部門ID"
    t.bigint "company_id", null: false, comment: "会社ID"
    t.boolean "is_admin", default: false, null: false, comment: "管理者フラグ"
    t.integer "working_status", comment: "ステータス"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  create_table "works", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.datetime "start_datetime", precision: nil, null: false, comment: "出勤日時"
    t.datetime "end_datetime", precision: nil, comment: "退勤日時"
    t.integer "total_work_time_in_minutes", default: 0, comment: "勤務開始から勤務終了までの合計時間"
    t.integer "total_break_time_in_minutes", default: 0, comment: "休憩時間の合計"
    t.integer "actual_work_time_in_minutes", default: 0, comment: "実労働時間"
    t.integer "total_overtime_in_minutes", default: 0, comment: "残業時間の合計"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "breaks", "works"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "departments"
  add_foreign_key "works", "users"
end

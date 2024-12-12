# db/migrate/20240916_create_works.rb
class CreateWorks < ActiveRecord::Migration[6.1]
  def change
    create_table :works do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID"
      t.datetime :start_datetime, comment: "出勤日時", null: false
      t.datetime :end_datetime, comment: "退勤日時"
      t.integer :total_work_time_in_minutes, comment: "勤務開始から勤務終了までの合計時間", default: 0
      t.integer :total_break_time_in_minutes, comment: "休憩時間の合計", default: 0
      t.integer :actual_work_time_in_minutes, comment: "実労働時間", default: 0
      t.integer :total_overtime_in_minutes, comment: "残業時間の合計", default: 0

      t.timestamps
    end
  end
end

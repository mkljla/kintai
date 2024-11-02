# db/migrate/20240916_create_attendances.rb
class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID"
      t.datetime :start_datetime, comment: "出勤時間"
      t.datetime :end_datetime, comment: "退勤時間"
      t.integer :total_working_time_in_minutes, comment: "労働時間"
      t.integer :total_overtime_in_minutes, comment: "残業時間"
      t.timestamps
    end
  end
end

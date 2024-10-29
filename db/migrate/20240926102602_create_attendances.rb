# db/migrate/20240916_create_attendances.rb
class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.references :user, foreign_key: true, comment: "ユーザーID"
      t.datetime :check_in_datetime, comment: "出勤時間"
      t.datetime :check_out_datetime, comment: "退勤時間"

      t.timestamps
    end
  end
end

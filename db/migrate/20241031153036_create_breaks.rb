class CreateBreaks < ActiveRecord::Migration[7.1]
  def change
    create_table :breaks do |t|
      t.references :attendance, null: false, foreign_key: true, comment: "Attendance ID"
      t.datetime :break_start_datetime, comment: "休憩開始時間"
      t.datetime :break_end_datetime, comment: "休憩終了時間"
      t.integer :total_break_time_in_minutes, comment: "休憩時間の合計"
      t.timestamps
    end
  end
end

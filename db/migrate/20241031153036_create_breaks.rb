class CreateBreaks < ActiveRecord::Migration[7.1]
  def change
    create_table :breaks do |t|
      t.references :work, null: false, foreign_key: true, comment: "Work ID"
      t.datetime :start_datetime, comment: "休憩開始時間"
      t.datetime :end_datetime, comment: "休憩終了時間"
      t.timestamps
    end
  end
end

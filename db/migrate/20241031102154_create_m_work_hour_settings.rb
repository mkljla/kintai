class CreateMWorkHourSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :m_work_hour_settings do |t|
      t.integer :standard_working_time_minutes, comment: "基本労働時間"
      t.date :applicable_start_date, comment: "適用開始日"
      t.date :applicable_end_date, comment: "適用終了日"

      t.timestamps
    end
  end
end

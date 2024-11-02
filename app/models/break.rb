class Break < ApplicationRecord
  # ===============
  # アソシエーション
  # ===============
  belongs_to :attendance
  # ===============
  # スコープ
  # ===============

  # created_atカラムを降順で取得する
  scope :sorted, -> { order(created_at: :desc) }


  # ===============
  # メソッド
  # ===============

  # 休憩中か判定
  def on_break?
    # 最新の休憩レコードに休憩開始記録が存在、かつ休憩終了記録が存在しない
    break_start_datetime.present? && break_end_datetime.nil?
  end

  # 休憩の新規作成と開始時間を登録
  def self.create_with_start_time(attendance)
    break_record = new(attendance_id: attendance.id, break_start_datetime: Time.current)
    break_record.save
  end

  # 休憩の終了時間を設定
  def set_end_time
    self.break_end_datetime = Time.current
    save
  end

end

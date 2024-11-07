class Break < ApplicationRecord
  # ===============
  # アソシエーション
  # ===============
  belongs_to :work
  # ===============
  # スコープ
  # ===============

  # created_atカラムを降順で取得する
  scope :sorted, -> { order(created_at: :desc) }


  # ===============
  # メソッド
  # ===============

  # 休憩中か判定
  def taking_a_break?
    # 最新の休憩レコードに休憩開始記録が存在、かつ休憩終了記録が存在しない
    start_datetime.present? && end_datetime.nil?
  end

  # 休憩の新規作成と開始時間を登録
  def self.create_with_start_time(work)
    break_record = new(work_id: work.id, start_datetime: Time.current)
    break_record.save
  end

  # 休憩の終了時間を設定
  def set_end_time
    self.end_datetime = Time.current
    save
  end

  # 休憩時間を計算する
  def calculate_total_break_time_in_minutes(break_record)
    break_seconds = break_record.end_datetime - break_record.start_datetime
    (break_seconds / 60).to_i
  end



end

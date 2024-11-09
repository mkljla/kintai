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

  # 休憩時間を計算
  def calculate_break_time
    self.end_datetime - self.start_datetime
  end

end

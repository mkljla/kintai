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

  # 休憩時間を計算
  def calculate_break_time
    self.end_datetime - self.start_datetime
  end

end

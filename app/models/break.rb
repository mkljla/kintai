class Break < ApplicationRecord
  # ===============
  # アソシエーション
  # ===============
  belongs_to :work

  # ===============
  # バリデーション
  # ===============
  validates :work_id, presence: true
  validates :start_datetime, presence: true, on: :create
  # validates :end_datetime, presence: true, on: :update #FIXME ステータスの更新がされない
  # validate :end_datetime_after_start_datetime, if: -> { end_datetime.present? } #FIXME ステータスの更新がされない

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

  def end_datetime_after_start_datetime
    return if start_datetime.blank?

    if end_datetime <= start_datetime
      errors.add(:end_datetime, "は休憩開始時間より後に設定してください")
    end
  end

end

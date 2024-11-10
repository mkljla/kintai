class Work < ApplicationRecord

  # ===============
  # アソシエーション
  # ===============

  belongs_to :user
  has_many :breaks

  # バリデーション
  validates :user_id, presence: true

  # ===============
  # スコープ
  # ===============

  # created_atカラムを降順で取得する
  scope :sorted, -> { order(created_at: :desc) }

  # ===============
  # メソッド
  # ===============

  # 勤務中か判定
  def working?
    # 最新のレコードに出勤記録が存在する、かつ退勤記録が存在しない
    start_datetime.present? && end_datetime.nil?
  end


  # 労働時間を計算
  def calculate_total_work_time
    self.end_datetime - self.start_datetime
  end

  # 実労働時間を計算
  def calculate_actual_work_time
    self.total_work_time_in_minutes - self.total_break_time_in_minutes
  end

  # 累計休憩時間を計算する
  def calculate_total_break_time
    # すべての関連する break レコードの break_time_in_minutes を合計
    breaks.sum(:break_time_in_minutes)
  end

  # 残業時間を計算するメソッド
  def calculate_overtime(standard_work_in_minutes)
    overtime = self.actual_work_time_in_minutes - standard_work_in_minutes
    overtime > 0 ? overtime : 0
  end


end

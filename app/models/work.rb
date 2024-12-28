class Work < ApplicationRecord

  # ===============
  # アソシエーション
  # ===============

  belongs_to :user
  has_many :breaks, dependent: :destroy

  # 仮想属性を設定
  attr_accessor :validation_context

  # バリデーション
  validates :user_id, presence: true
  validates :start_datetime, presence: true, on: :create
  validates :end_datetime, :total_work_time_in_minutes, :actual_work_time_in_minutes, :total_overtime_in_minutes, presence: true, if: -> { validation_context == :work_update }
  validates :total_break_time_in_minutes, presence: true, if: -> { validation_context == :break_update }

  # ===============
  # スコープ
  # ===============

  # created_atカラムを降順で取得する
  scope :sorted, -> { order(created_at: :desc) }
  # 今日作成されたレコード
  scope :today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  # 最新のレコード
  scope :latest_one, -> { order(created_at: :desc).limit(1) }


  # ===============
  # メソッド
  # ===============

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
    overtime = self.actual_work_time_in_minutes - (Company.find_by(id: 1)&.default_work_hours)
    overtime > 0 ? overtime : 0
  end

  private

end

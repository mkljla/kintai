class Attendance < ApplicationRecord

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

  # 出勤済か判定
  def checked_in?
    # 最新のレコードに出勤記録が存在する、かつ退勤記録が存在しない
    check_in_datetime.present? && check_out_datetime.nil?
  end


  # 出勤記録の新規作成と出勤時間を登録
  def self.create_with_check_in(user)
    attendance_record = new(user_id: user.id, check_in_datetime: Time.current)
    attendance_record.save
  end

  # 退勤時間を設定する
  def set_check_out
    self.check_out_datetime = Time.current
  end

  # 勤務時間を時間単位で計算するメソッド
  def working_hours
    return nil unless check_in_datetime && check_out_datetime
    (check_out_datetime - check_in_datetime) / 3600.0
  end

  # 残業時間を計算するメソッド
  def overtime_hours(normal_hours = 8)
    return nil unless working_hours
    overtime = working_hours - normal_hours
    overtime.positive? ? overtime : 0
  end


end

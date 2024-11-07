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


  # 出勤記録の新規作成と出勤時間を登録
  def self.create_work_record(user)
    work_record = new(user_id: user.id, start_datetime: Time.current)
    work_record.save
  end

  # 退勤時間を設定する
  def register_work_end_time
    self.end_datetime = Time.current
    save
  end

  # 労働時間を計算する
  def calculate_total_working_time_in_minutes(work_record)
    working_seconds = work_record.end_datetime - work_record.start_datetime
    (working_seconds / 60).to_i
  end


  # 労働時間を登録する
  def register_total_working_time(total_working_time)
    self.total_working_time_in_minutes = total_working_time
    save!
  end


  # 累計休憩時間を登録する
  def register_total_break_time_in_minutes(break_time_in_minutes)
    self.total_break_time_in_minutes =+ break_time_in_minutes
    save
  end

  # # 残業時間を計算するメソッド
  # def overtime_hours(normal_hours = 8)
  #   return nil unless working_hours
  #   overtime = working_hours - normal_hours
  #   overtime.positive? ? overtime : 0
  # end


end

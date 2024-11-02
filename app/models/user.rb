class User < ApplicationRecord

  # ===============
  # アソシエーション
  # ===============
  has_many :attendances
  belongs_to :department, optional: true # nilを許容
  has_many :breaks, through: :attendances # attendanceを経由してbreaksを取得

  # ===============
  # バリデーション
  # ===============
  validates :employee_number, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :date_of_hire, presence: true
  validates :password_digest, presence: true

  # パスワードをハッシュ化
  has_secure_password

  # ===============
  # スコープ
  # ===============

  # 社員番号の小さい順に並び替え
  scope :ordered_by_employee_number, -> { order(:employee_number) }

  #退職済みユーザー絞り込み
  scope :retired, ->{where.not(date_of_termination: nil)}

  #在職ユーザー絞り込み
  scope :active, -> { where(date_of_termination: nil) }

  # ===============
  # メソッド
  # ===============

  # 勤務ステータスを返すメソッド
  def working_status
    latest_attendance = attendances.order(created_at: :desc).first
    if latest_attendance&.check_in_datetime.present? && latest_attendance.check_out_datetime.nil?
      "勤務中"
    else
      "退勤"
    end
  end

end

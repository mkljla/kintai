class User < ApplicationRecord
  # ===============
  # バリデーション
  # ===============
  validates :employee_number, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :date_of_hire, presence: true
  validates :password_digest, presence: true

  # ===============
  # アソシエーション
  # ===============
  has_many :attendances
  belongs_to :department, optional: true # nilを許容

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
end

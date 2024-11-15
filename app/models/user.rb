class User < ApplicationRecord

  # ===============
  # アソシエーション
  # ===============
  has_many :works
  belongs_to :department, optional: true # nilを許容
  has_many :breaks, through: :works # workを経由してbreaksを取得

  # ===============
  # バリデーション
  # ===============
  has_secure_password # パスワードをハッシュ化
  validates :employee_number, :first_name, :family_name, :birthday, :date_of_hire, presence: true
  validates :employee_number, uniqueness: true
  validates :first_name, :family_name, length: { maximum: 30 }, format: { with: /\A[ぁ-んァ-ン一-龥a-zA-Z]/ , message: "はひらがな、カタカナ、漢字、またはアルファベットで入力してください" }
  validates :first_name_kana, :family_name_kana, allow_blank: true, length: { maximum: 30 }, format: { with: /\A[ぁ-ん]+\z/ , message: "はひらがなで入力してください" }


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

  # 勤務中か判定
  def working?
    latest_work = works.order(created_at: :desc).first
    # 最新のレコードに出勤記録が存在する、かつ退勤記録が存在しない
    latest_work.present? && latest_work.start_datetime.present? && latest_work.end_datetime.nil?
  end

  # 休憩中か判定
  def taking_a_break?
    latest_break = breaks.order(created_at: :desc).first
    # 最新の休憩レコードに休憩開始記録が存在、かつ休憩終了記録が存在しない
    latest_break.start_datetime.present? && latest_break.end_datetime.nil?
  end

  # 新規ユーザーの社員番号を取得
  def self.next_employee_number
    latest_employee_number  = User.maximum(:employee_number).to_i
    latest_employee_number + 1
  end

end

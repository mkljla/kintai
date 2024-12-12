class User < ApplicationRecord

  # ===============
  # アソシエーション
  # ===============
  has_many :works, dependent: :destroy
  has_many :breaks, through: :works  # workを経由してbreaksを取得
  belongs_to :department, optional: true # nilを許容

  # ===============
  # enum 定義
  # ===============
  enum working_status: {
    working: 0,       # 勤務している
    breaking: 1,      # 休憩中
    not_working: 2,   # 勤務していない
    retired: 3        # 退職している
  }

  # ===============
  # バリデーション
  # ===============
  has_secure_password # パスワードをハッシュ化

  # Presence validations
  validates:employee_number, :first_name, :family_name, :birthday, :date_of_hire, presence: true
  # Uniqueness validation
  validates :employee_number, uniqueness: true
  # Length and format validations
  with_options length: { maximum: 20 }, format: {
    with: /\A[ぁ-んァ-ン一-龥a-zA-Z]/,
    message: "はひらがな、カタカナ、漢字、またはアルファベットで入力してください"
  } do
    validates :first_name
    validates :family_name
  end

  with_options length: { maximum: 30 }, allow_blank: true, format: {
    with: /\A[ぁ-ん]+\z/,
    message: "はひらがなで入力してください"
  } do
    validates :first_name_kana
    validates :family_name_kana
  end

  # ===============
  # スコープ
  # ===============

  # adminユーザー以外を取得
  scope :non_admin, ->{ where(is_admin: false) }

  # 社員番号の小さい順に並び替え
  scope :ordered_by_employee_number, -> { order(:employee_number) }

  #退職済みユーザー(退職カラムが存在するかつ、退職日が過去)
  scope :retired, -> { where.not(date_of_termination: nil).where('date_of_termination < ?', Date.today) }

  #在職ユーザー(退職カラムが存在しないもしくは、退職カラムが存在かつ退職日が今日以降)
  scope :active, -> { where(date_of_termination: nil).or(where('date_of_termination >= ?', Date.today)) }

  # ===============
  # メソッド
  # ===============

  # 勤務中か判定
  def working?
    latest_work = works.order(created_at: :desc).first
    # 最新のレコードに出勤記録が存在する、かつ退勤記録が存在しない
    latest_work&.start_datetime.present? && latest_work&.end_datetime.nil?
  end

  # 休憩中か判定
  def taking_a_break?
    latest_break = breaks.order(created_at: :desc).first
    # 最新の休憩レコードに休憩開始記録が存在、かつ休憩終了記録が存在しない
    latest_break&.start_datetime.present? && latest_break&.end_datetime.nil?
  end


  # 新規ユーザーの社員番号を取得
  def self.next_employee_number
    latest_employee_number  = User.maximum(:employee_number).to_i
    latest_employee_number + 1
  end

  # working_statusを文字列に変換
  def working_status_str
    case working_status
    when "working"
      "勤務中"
    when "breaking"
      "休憩中"
    when "not_working"
      "勤務外"
    when "retired"
      "退職"
    else
      "未登録"
    end
  end

  # 在職か判定
  def active?
    date_of_termination.nil? || date_of_termination >= Date.today
  end

end

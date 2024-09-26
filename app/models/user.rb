class User < ApplicationRecord
  # バリデーション
  validates :employee_number, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :date_of_hire, presence: true
  validates :password_digest, presence: true

  # アソシエーション
  belongs_to :department

  # パスワードをハッシュ化
  has_secure_password
end

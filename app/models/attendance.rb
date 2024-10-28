class Attendance < ApplicationRecord
  # アソシエーション
  belongs_to :user

  # バリデーション
  validates :user_id, presence: true

end

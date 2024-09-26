class Attendance < ApplicationRecord
  # アソシエーション
  belongs_to :user

  # バリデーション
  validates :employee_id, presence: true
  validates :date, presence: true
  validates :check_in_time, presence: true, if: -> { check_out_time.nil? }
  validates :check_out_time, presence: true, if: -> { check_in_time.present? }
end

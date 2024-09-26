class Department < ApplicationRecord
  # アソシエーション
  has_many :users, dependent: :destroy

  # バリデーション
  validates :name, presence: true
end

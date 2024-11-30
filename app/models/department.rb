class Department < ApplicationRecord
  # アソシエーション
  has_many :users

  # バリデーション
  validates :name, presence: true

  # sort_noカラムを昇順で取得する
  scope :sorted, -> { order(sort_no: :asc) }

end

class Company < ApplicationRecord
    has_many :users

    # バリデーション
    validates :name, :default_work_hours, presence: true
    validates :name, length: { maximum: 50 }, format: { with: /\A[ぁ-んァ-ン一-龥a-zA-Z０-９Ａ-Ｚａ-ｚ]+\z/ }
    validates :default_work_hours, format: { with: /\A\d+(\.\d{1})?\z/ }

end

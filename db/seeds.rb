# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 部門データの作成
Department.create!(name: '総務')
Department.create!(name: '経理')

# ユーザーデータの作成
5.times do |n|
# ユーザーデータの作成
User.create!(
  employee_number: (n + 1).to_s.rjust(4, '0'),
  full_name: "テスト太郎#{n + 1}",
  date_of_hire: Date.new(2020, 1, 1),
  password: "password#{n + 1}", # password_digestではなく、passwordを指定
  department_id: n % 2 + 1
)

end

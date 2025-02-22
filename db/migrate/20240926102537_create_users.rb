# db/migrate/20240916_create_users.rb
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :employee_number, null: false, unique: true, comment: "社員番号"
      t.string :full_name, comment: "フルネーム"
      t.string :family_name, null: false, comment: "姓", limit: 20
      t.string :first_name, null: false, comment: "名", limit: 20
      t.string :family_name_kana, null: false, comment: "姓(かな)", limit: 30
      t.string :first_name_kana, null: false, comment: "名(かな)", limit: 30
      t.string :full_name_kana, comment: "フルネーム(かな)"
      t.date :birthday, null: false, comment: "生年月日"
      t.date :date_of_hire, null: false, comment: "入社日"
      t.date :date_of_termination, comment: "退職日"
      t.string :password_digest, null: false, comment: "パスワード（ハッシュ）"
      t.references :department, foreign_key: true, comment: "部門ID"
      t.references :company, foreign_key: true, null: false, comment: "会社ID"
      t.boolean :is_admin, default: false, null: false, comment: "管理者フラグ"
      t.integer :working_status, comment: "ステータス"
      t.timestamps
    end
  end
end

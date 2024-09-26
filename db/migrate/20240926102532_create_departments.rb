# db/migrate/20240916_create_departments.rb
class CreateDepartments < ActiveRecord::Migration[6.1]
  def change
    create_table :departments do |t|
      t.string :name, null: false, comment: "部門名"
      t.integer :sort_no, comment: "表示順"

      t.timestamps
    end
  end
end

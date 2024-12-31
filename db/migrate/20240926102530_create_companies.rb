class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false, comment: "会社名", limit: 50
      t.float :default_work_hours, null: false, comment: "基本労働時間"

      t.timestamps
    end
  end
end

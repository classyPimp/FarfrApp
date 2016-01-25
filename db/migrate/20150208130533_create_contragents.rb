class CreateContragents < ActiveRecord::Migration
  def change
    create_table :contragents do |t|
      t.string :corporate_form
      t.string :name

      t.timestamps null: false
    end
  end
end

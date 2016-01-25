class CreateAssignees < ActiveRecord::Migration
  def change
    create_table :assignees do |t|
      t.references :user, index: true
      t.references :assignment, index: true
      t.text :text_report
      t.text :log

      t.timestamps null: false
    end
    add_foreign_key :assignees, :users
    add_foreign_key :assignees, :assignments
  end
end

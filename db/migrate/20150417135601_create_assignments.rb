class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|

      t.timestamps null: false
      t.integer :assignable_id
      t.string :assignable_type
      t.string :type
      t.references :user, index: true
      t.references :parent, index: true
      t.text :assignment_details
      t.string :short_description
      t.text :log
      t.datetime :deadline
      t.datetime :completion_confirmed

    end
      add_index :assignments, :assignable_id
      add_index :assignments, :assignable_type
      add_foreign_key :assignments, :assignments, column: :parent_id
      
  end
end


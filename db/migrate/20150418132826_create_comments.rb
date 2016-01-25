class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.references :user
      t.references :parent, index: true
      t.text :log
      t.string :type

      t.timestamps null: false
    end
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
    add_index :comments, :type
    add_foreign_key :comments, :comments, column: :parent_id
  end
end

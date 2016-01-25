class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.integer :confirmable_id
      t.string :confirmable_type
      t.string :type
      t.integer :initiator
      t.integer :confirmator
      t.string :confirmator_note
      t.datetime :confirmed

      t.timestamps null: false
    end
    add_index :confirmations, :confirmable_type
    add_index :confirmations, :type
    add_index :confirmations, :initiator
    add_index :confirmations, :confirmator
    add_foreign_key :confirmations, :users, column: :initiator, primary_key: :id
    add_foreign_key :confirmations, :users, column: :confirmator, primary_key: :id 
  end
end

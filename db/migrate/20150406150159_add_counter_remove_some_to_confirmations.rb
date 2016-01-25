class AddCounterRemoveSomeToConfirmations < ActiveRecord::Migration
  def change
    change_table :confirmations do |t|
      t.rename :confirmator_note, :note
    end

    remove_column :confirmations, :confirmator, :integer
    change_column :confirmations, :confirmed, :integer
    add_index :confirmations, :confirmed
    
  end
end

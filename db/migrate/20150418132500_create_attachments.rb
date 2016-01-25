class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.string :type

      t.timestamps null: false
      

    end
    add_attachment :attachments, :attachment
    add_index :attachments, :attachable_id
    add_index :attachments, :attachable_type
    add_index :attachments, :type
  end
end

class AddDescriptionToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :description, :text
    add_column :attachments, :log, :text
  end
end

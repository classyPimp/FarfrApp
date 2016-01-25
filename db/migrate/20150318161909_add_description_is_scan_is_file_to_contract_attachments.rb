class AddDescriptionIsScanIsFileToContractAttachments < ActiveRecord::Migration
  def change
    add_column :contract_attachments, :description, :string
    add_column :contract_attachments, :is_final, :boolean
    add_column :contract_attachments, :is_scan, :boolean
  end
end

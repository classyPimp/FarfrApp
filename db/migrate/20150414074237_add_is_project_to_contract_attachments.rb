class AddIsProjectToContractAttachments < ActiveRecord::Migration
  def change
    add_column :contract_attachments, :is_project, :boolean
  end
end

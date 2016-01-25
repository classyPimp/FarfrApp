class AddAttachmentToContractAttachments < ActiveRecord::Migration
  def change
    add_attachment :contract_attachments, :document
  end
end

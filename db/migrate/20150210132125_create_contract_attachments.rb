class CreateContractAttachments < ActiveRecord::Migration
  def change
    create_table :contract_attachments do |t|
      t.references :contract, index: true

      t.timestamps null: false
    end
    add_foreign_key :contract_attachments, :contracts
  end
end

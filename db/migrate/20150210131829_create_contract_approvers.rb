class CreateContractApprovers < ActiveRecord::Migration
  def change
    create_table :contract_approvers do |t|
      t.references :contract, index: true
      t.references :user, index: true
      t.string :approved
      t.string :notified
      t.text :log

      t.timestamps null: false
    end
    add_foreign_key :contract_approvers, :contracts
    add_foreign_key :contract_approvers, :users
  end
end

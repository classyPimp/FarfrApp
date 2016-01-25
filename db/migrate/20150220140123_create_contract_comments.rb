class CreateContractComments < ActiveRecord::Migration
  def change
    create_table :contract_comments do |t|
      t.references :contract, index: true
      t.references :user, index: true
      t.references :parent, index: true
      t.integer :parent_node
      t.string :satisfied
      t.string :read
      t.text :log
      t.text :claims

      t.timestamps null: false
    end
    add_foreign_key :contract_comments, :contracts
    add_foreign_key :contract_comments, :users
    add_foreign_key :contract_comments, :parents
  end
end

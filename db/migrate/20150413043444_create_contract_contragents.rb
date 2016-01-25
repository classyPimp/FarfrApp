class CreateContractContragents < ActiveRecord::Migration
  def change
    create_table :contract_contragents do |t|
      t.references :contract, index: true
      t.references :contragent, index: true

      t.timestamps null: false
    end
    add_foreign_key :contract_contragents, :contracts
    add_foreign_key :contract_contragents, :contragents
  end
end

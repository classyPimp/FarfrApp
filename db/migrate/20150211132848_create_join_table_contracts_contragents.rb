class CreateJoinTableContractsContragents < ActiveRecord::Migration
  def change
    create_join_table :contracts, :contragents do |t|
       t.index [:contract_id, :contragent_id]
       t.index [:contragent_id, :contract_id]
    end
  end
end

class AddIsExecutorToContractApprovers < ActiveRecord::Migration
  def change
    add_column :contract_approvers, :is_executor, :boolean
  end
end

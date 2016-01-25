class AddVisitedToContractApprovers < ActiveRecord::Migration
  def change
    add_column :contract_approvers, :visited, :datetime
  end
end

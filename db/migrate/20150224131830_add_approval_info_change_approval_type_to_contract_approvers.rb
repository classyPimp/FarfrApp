class AddApprovalInfoChangeApprovalTypeToContractApprovers < ActiveRecord::Migration
  def change
    add_column :contract_approvers, :approval_info, :text
    change_column :contract_approvers, :approved, :datetime
  end
end

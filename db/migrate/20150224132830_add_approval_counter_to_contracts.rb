class AddApprovalCounterToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :approval_counter, :integer
    add_column :contracts, :approved, :datetime
  end
end

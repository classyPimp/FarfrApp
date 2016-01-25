class RemovePendingConfirmationsFromContracts < ActiveRecord::Migration
  def change
    remove_column :contracts, :pending_confirmations, :text
  end
end

class AddPendingConfirmationsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :pending_confirmations, :text
    add_index :contracts, :pending_confirmations
  end
end

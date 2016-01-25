class AddAfterAprovalColumnsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :signed_by_company, :datetime
    add_column :contracts, :sent_to_contragent, :datetime
    add_column :contracts, :recieved_from_contragent, :datetime
    add_column :contracts, :kept_at, :string
  end
end

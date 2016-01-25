class AddBodyToContractComments < ActiveRecord::Migration
  def change
    add_column :contract_comments, :body, :text
  end
end

class AddParentNodeToComments < ActiveRecord::Migration
  def change
    add_column :comments, :parent_node, :integer
  end
end

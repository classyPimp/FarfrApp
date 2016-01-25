class AddCompletedToAssignees < ActiveRecord::Migration
  def change
    add_column :assignees, :completed, :datetime
  end
end

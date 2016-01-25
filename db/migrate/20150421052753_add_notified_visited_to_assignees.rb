class AddNotifiedVisitedToAssignees < ActiveRecord::Migration
  def change
    add_column :assignees, :notified, :datetime
    add_column :assignees, :visited, :datetime
  end
end

class AddReportFormToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :report_form, :string
  end
end

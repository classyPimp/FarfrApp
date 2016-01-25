class AddSubjectToConfirmations < ActiveRecord::Migration
  def change
    add_column :confirmations, :subject, :string
  end
end

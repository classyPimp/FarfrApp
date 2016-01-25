class CreateConfirmationStatuses < ActiveRecord::Migration
  def change
    create_table :confirmation_statuses do |t|
      t.references :confirmation, index: true
      t.references :user, index: true
      t.datetime :confirmed
      t.datetime :notified
      t.text :log
      t.string :confirmators_note
    end
    add_foreign_key :confirmation_statuses, :confirmations
    add_foreign_key :confirmation_statuses, :users
  end
end

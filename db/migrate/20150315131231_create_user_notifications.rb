class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.references :user, index: true
      t.string :subject
      t.string :link
      t.datetime :read

      t.timestamps null: false
    end
    add_foreign_key :user_notifications, :users
  end
end

class ContractComment < ActiveRecord::Base
#==========SCHEMA
=begin
def change
    create_table :contract_comments do |t|
      t.references :contract, index: true
      t.references :user, index: true
      t.references :parent, index: true
      t.integer :parent_node
      t.string :satisfied
      t.string :read
      t.text :log
      t.text :claims
      add_column :contract_comments, :body, :text
      t.timestamps null: false
    end
    add_foreign_key :contract_comments, :contracts
    add_foreign_key :contract_comments, :users
    add_foreign_key :contract_comments, :parents
  end
end
=end
#============ASSOCIATIONS
  belongs_to :contract, inverse_of: :comments
  belongs_to :user, inverse_of: :contract_comments
  belongs_to :parent, class_name: :ContractComment

#============VALIDATIONS
  validates_presence_of :parent_id, :user_id, :contract_id, :body, :parent_node

#============CALLBACKS
  after_create :notify_interested_users
  after_update :on_comment_satisfied, if: (Proc.new do |o|
      o.satisfied != 0
    end) 

#============CALLBACK METHODS
 protected
  def notify_interested_users
    UserNotification.notify_users_of_comment_creation(contract_id, id, user_id, parent_id)
  end
  #---------NOTIFY OBSERVERS
  def on_comment_satisfied
    UserNotification.on_confirmation(self, {subject: 'contract:comment_satisfied'})
  end
end

class Confirmation < ActiveRecord::Base
=begin
   def change
    create_table :confirmations do |t|
      t.integer :confirmable_id
      t.string :confirmable_type
      t.string :type
      t.integer :initiator
      t.string :note
      t.datetime :confirmed
      t.varchar :subject

      t.timestamps null: false
    end
    add_index :confirmations, :confirmable_type
    add_index :confirmations, :type
    add_index :confirmations, :initiator
    add_index :confirmations, :confirmator
    add_foreigin_key :confirmations, :users, column: :initiator, primary_key: :id
    add_foreigin_key :confirmations, :users, column: :confirmator, primary_key: :id 
  end
=end


#-------------ASSOCIATIONS
belongs_to :confirmable, polymorphic: true
has_many :statuses, class_name: '::ConfirmationStatus'
belongs_to :initiator_user, class_name: '::User', foreign_key: :initiator

#=---------ASSOCIATION WITH SCOPES
 

#-------------ACCEPTS NESTED ATTRIBUTES

accepts_nested_attributes_for :statuses

#-------------VALIDATIONS

validate :statuses_should_be_more_than_one, on: :create
validates_presence_of :initiator

#----------VALIDATION METHODS

def statuses_should_be_more_than_one
  counter = self.statuses.size
  if counter < 1
    self.errors.add :base, 'confirmator.size !> 1'
    return false
  end
end 

#-------------CALLBACKS
  after_update :on_confirmation, if: :confirmed?
  after_validation :assign_confirm_counter, on: :create

#--------------CALLBACK METHODS
        #--------THIS METHOD TO NOTIFY OBSERVERS OF CONFIRMATION
def on_confirmation 
  UserNotification.on_confirmation(self)
  if self.class == ContractKeptAtConfirmation
    self.confirmable.contract_kept_at_confirmed(self.statuses.first.user_id)
  end
end

def confirmed?
  if self.confirmed == 0
    true
  else
    false
  end
end

def assign_confirm_counter
  self.confirmed = self.statuses.size
end 
=begin
def set_confirmed_counter
  counter = self.statuses.size
  if counter < 1
    self.errors.add :base, 'confirmator.size !> 1'
    return false
  end
  self.confirmed = counter
end
=end

#-------------RECIEVED FROM OBSERVABLES
  def on_status_confirmed
    self.confirmed -= 1
    self.save
  end




end

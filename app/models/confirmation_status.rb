class ConfirmationStatus < ActiveRecord::Base

=begin
create_table "confirmation_statuses", force: :cascade do |t|
    t.integer  "confirmation_id"
    t.integer  "user_id"
    t.datetime "confirmed"
    t.datetime "notified"
    t.text     "log"
    t.string   "confirmators_note"
  end
=end
  

#--------------ASSOCIATIONS
  belongs_to :confirmation
  belongs_to :user

#--------------VALIDATIONS
  validates_presence_of :user_id

#--------------MODULE INCLUSIONS
  
  include ConfirmationServices::KeptAt::ConfirmationStatus

#------------CALLBACKS
  after_update :on_status_confirmed, if: :user_confirmed?
#-------------CALLBACK METHODS

  def user_confirmed?
    if self.confirmed != nil
      true
    else 
      false
    end 
  end
        #-----------OBSERVERLIKE NOTIFICATION
  def on_status_confirmed
    self.confirmation.on_status_confirmed
  end

end

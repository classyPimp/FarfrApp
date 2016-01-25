module ConfirmationServices::KeptAt
   
#------------------CONTRACT CLASS | INSTANCE METHODS
  module Contract

  end

#-----------------CONTRACTKEPTATCONFIRMATION CLASS | INSTANCE METHODS
  module ContractKeptAtConfirmation 
    
   # def self.included(base) 
      #base.validate :statuses_should_be_more_than_one -- in Confirmation
      #base.validates_presence_of :initiator -- in Confirmation
      #base.after_validation :assign_confirm_counter, on: :create =-- in Confirmaiton
      #base.after_update :on_contract_kept_at_confirmed, if: :confirmed? 
   # end
=begin
    def statuses_should_be_more_than_one
      if (@statuses_size = self.statuses.size) < 1
        errors.add :base, 'statuses shall be more than one' 
      end
    end

    def assign_confirm_counter
      self.confirmed = @statuses_size
    end   
=end
  end

#---------------STATUS CLASS | INSTANCE METHODS
  module ConfirmationStatus
=begin
    def self.included(base)
      #base.validates_presence_of :user_id
      base.after_update :notify_users_of_kept_at_confirmation, :decrement_confirm_counter_on_confirmation, if: :user_confirmed?
    end
      #------------CALLBACKS   
    def notify_users_of_kept_at_confirmation
      #contract_id = self.confirmation.confirmable_id
      UserNotification.notify({contract_id: contract_id, notification_for: 'contract', subject: 'kept_at_confirmation', user_id: self.user_id})
    end

    def user_confirmed?
      if self.confirmed.changed?
        true
      else
        false  
      end
    end
=end
  end

end
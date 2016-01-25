class ContractKeptAtConfirmation < Confirmation

#-----------MODULE INCLUSIONS

  include ConfirmationServices::KeptAt::ContractKeptAtConfirmation

#---------ASSOCIATIONS

  belongs_to :confirmable, polymorphic: true

  belongs_to :keeper, class_name: :user, foreign_key: :subject


#---------ACCEPTS NESTED ATTRIBUTES

  

#---------VALIDATIONS

  #validates_presence_of :initiator ----moved to Confirmation

#----------VALIDATION METHODS
  

#---------CALLBACKS
  

#---------CALLBACK METHODS
  



#----------SCOPELIKE METHODS

  

#----------CLASS METHODS

  def self.mass_confirm(self_ids, user_id)
    confirmations = self.where(id: self_ids).includes(:statuses).where('confirmation_statuses' => {user_id: user_id})
    confirmations.each do |c|
      c.statuses.first.update(confirmed: Time.now)
    end 
  end

end

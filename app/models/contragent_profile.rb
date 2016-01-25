class ContragentProfile < ActiveRecord::Base

#==========COLUMNS
          #address:string
          #director:string
          #bank_account:string
          #postal_address:string
          #contacts:string
#+++++++++++
#========ASSOCIATIONS
  belongs_to :contragent

#========VALIDATIONS
  validates_presence_of :address, :director
end

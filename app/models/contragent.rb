class Contragent < ActiveRecord::Base
  
#=====COLUMNS
     # t.string :corporate_form
     # t.string :name
     # t.timestamps null: false

#-----------ASSOCIATIONS
  has_one :contragent_profile, dependent: :destroy
  #has_and_belongs_to_many :contracts

  has_many :contract_contragents, class_name: :ContractContragent, inverse_of: :contragent
  has_many :contracts, through: :contract_contragents 
#-----------NESTED ATTRIBUTES
  accepts_nested_attributes_for :contragent_profile, allow_destroy: true
#-----------VALIDATION
  validates_presence_of :corporate_form, :name
   
  
end

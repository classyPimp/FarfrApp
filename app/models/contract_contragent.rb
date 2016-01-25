class ContractContragent < ActiveRecord::Base

#---------ASSOCIATIONS
  belongs_to :contract, inverse_of: :contract_contragents
  belongs_to :contragent, inverse_of: :contract_contragents


end

class ContractApprover < ActiveRecord::Base
#------------------
  #  t.references :contract, index: true
  #  t.references :user, index: true
  #  t.string :notified
  #  t.text :log
  #  t.timestamps null: false
  #  add_column :contract_approvers, :approval_info, :text
  #  change_column :contract_approvers, :approved, :datetime
#----------------------SERIALIZED COLUMNS

  serialize :log, Hash

#----------------------ASSOCIATIONS
 
  belongs_to :contract, inverse_of: :approvers
  belongs_to :user, inverse_of: :approvers


#--------------CALLBACKS 

#--------------SERVICE METHODS

  def self.set_contract_visited_on_visit(contract_id, current_user_id)
    contract = ContractApprover.where(contract_id: contract_id, user_id: current_user_id).first
    unless contract.nil?
      if contract.visited == nil
        contract.visited = Time.now 
        contract.save
      end
    end
  end

#--------------CALLBACK METHODS

#--------------CLASS METHODS

  def self.pluck_ids_for_contract(contract_id)
    select(:user_id).where(contract_id: contract_id).pluck(:user_id)
  end 

#-------------RECIEVED FROM OBSERVABLES

  def on_project_upload(object)
    
  end

end

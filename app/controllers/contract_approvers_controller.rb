class ContractApproversController < ApplicationController

#=============ACTION METHODS
  def update
    set_notified_if_querried and return
    render nothing: true, status: 200
  end

  def show
    render "users/_unapproved_contracts_for_user"
  end
#=============ACTION SUBMETHODS
  def set_notified_if_querried
    unless params[:contract_ids].blank?
      @contract_approvers = ContractApprover.where(user_id: params[:user_id], 
        contract_id: params[:contract_ids])
      if @contract_approvers.update_all(notified: Time.now)
        render(nothing: true, status: 200) and return true
      else
        render(nothing: true, status: :error) and return true
      end   
    end
  end 
end



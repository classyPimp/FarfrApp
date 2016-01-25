module ContractsHelper
  
  def check_executor_and_approved_for_loaded_contract(contract)
    executor = contract.approvers.select do |c|
      c.is_executor != nil && c.user_id == current_user.id
    end

    approved = contract.approved

    if executor.blank? || approved.nil?
      return false
    else
      return true
    end
  end

  def current_user_is_executor_for_loaded_contract?(contract)
    executor = contract.approvers.select do |c|
      c.is_executor != nil && c.user_id == current_user.id
    end
    if executor.blank?
      return false
    else
      return true
    end
  end

end

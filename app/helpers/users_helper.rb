module UsersHelper
  
  def unapproved_contracts_for_current_user
    @unapproved_contracts_for_current_user ||= {}
    ##refactor with single map eg [u_c] << c if condition and so on
    @unapproved_contracts_for_current_user[:contracts] ||= Contract.unapproved_contracts_for_user(current_user.id)
    @unapproved_contracts_for_current_user[:unapproved_counter] ||= (@unapproved_contracts_for_current_user[:contracts].select {|contract| contract[:u_approved] == nil}).count
    @unapproved_contracts_for_current_user[:unnotified_ids] ||= @unapproved_contracts_for_current_user[:contracts].map {|c| c[:id] if c[:notified] == nil}.compact
    @unapproved_contracts_for_current_user
  end

end

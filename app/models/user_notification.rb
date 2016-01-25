class UserNotification < ActiveRecord::Base
#=========SCHEMA
=begin
      t.references :user, index: true
      t.string :subject
      t.string :link
      t.datetime :read
      t.timestamps null: false
=end
  belongs_to :user, inverse_of: :user_notifications


#---------VALIDATION
  validates_presence_of :user_id, :subject, :link

#------------CLASS METHODS
  def self.notify_users_of_contract_approval_by_all(contract_id, contract_number, user_name, approver)
    user_ids = ContractApprover.pluck_ids_for_contract(contract_id) - [approver.id.to_i]  
    user_ids.map! do |index|
      { user_id: index, subject: "Contract #" + Contract.select(:number).find(contract_id).number + " was approved by #{user_name}",
                   link: Rails.application.routes.url_helpers.contract_path(contract_id) }
    end
    self.create(user_ids)
  end

  def self.notify_users_of_comment_creation(contracts_id, comment_id, current_user, parent_id)
    user_ids = ContractApprover.pluck_ids_for_contract(contracts_id) - [current_user]
    user_ids.map! {|index| { user_id: index, subject: ((parent_id == 0) ? "new objection added to " : "new comment added to ") + 
                   Contract.select(:number).find(contracts_id).number,
                   link: Rails.application.routes.url_helpers.contract_path(contracts_id) } }
    self.create(user_ids)
  end

  def self.notify(arg)
    raise "Hash must be arged to UserNotification.notify" unless arg.class == Hash

    if arg[:notification_for] == 'contract' && arg[:subject] != nil && arg[:contract_id] != nil
      user_ids = Contract.select(:id).find(arg[:contract_id]).approvers.pluck(:id) - [arg[:user_id]]
      user_ids.map! do |index|
        {user_id: index, link: arg[:contract_id], subject: ('contract:' + arg[:subject])}
      end
      self.create(user_ids)      
    end    
  end

#---------------SUBSCRIPTION METHODS
  def self.on_confirmation(object = nil, options = {})
    if object.class == ContractKeptAtConfirmation && object.confirmable_type == 'Contract'
      user_ids = object.confirmable.approvers.pluck(:user_id)
      user_ids.map! do |index|
        {user_id: index, link: object.confirmable.id, subject: ('contract:kept_at_confirmation')}
      end
    end
    if object.class == ContractAttachment 
      user_ids = object.contract.approvers.pluck(:user_id)
      user_ids.map! do |index|
        {user_id: index, link: object.contract.id, subject: ('contract:is_project_uploaded')}
      end     
    end
    if options[:subject] == 'contract:comment_satisfied'
      user_ids = object.contract.approvers.pluck(:user_id)
      user_ids.map! do |index|
        {user_id: index, link: object.contract_id, subject: ('contract:comment_satisfied')}
      end
    end
    if options[:subject] == 'assignment:created'
      user_ids = object.assignees.pluck(:user_id)
      user_ids.map! do |index|
        {user_id: index, link: object.id, subject: 'assignment:created'}
      end
    end
    if options[:subject] == 'assignee:report_filed'
      user_ids = ( object.attachable.assignment.assignees.pluck(:user_id) << object.attachable.assignment.user.id) - ([] << object.attachable.user_id) 
      user_ids.map! do |index|
        {user_id: index, link: object.id, subject: 'assignee:report_filed'}
      end
    end
    if options[:subject] == 'assignment:completion_confirmed'
      user_ids = object.assignees.pluck(:user_id)
      user_ids.map! do |index|
        {user_id: index, link: object.id, subject: 'assignment:completion_confirmed'}
      end
    end
    self.create(user_ids)     
  end

end

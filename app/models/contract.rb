class Contract < ActiveRecord::Base
   #||||||||||||||||||||||||||TODO: Add inverse_of to belongs_to models
#+++++++++++++++++++++++
=begin
    t.string   "number" 
    t.string   "date"
    t.string   "subject"
    t.string   "short_description"
    t.integer  "parent_id"
    t.text     "log"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "approval_counter"
    t.datetime "approved"
    t.datetime "signed_by_company"
    t.datetime "sent_to_contragent"
    t.datetime "recieved_from_contragent"
    t.string   "kept_at"
    add_column :contracts, :pending_confirmations, :text ---removed
    add_index :contracts, :pending_confirmations ----removed
=end
#+++++++++++++++++++++++++
##TODO: make distinct difference and set of rules for contract template e.g. it can
#be either extra field like is_template:integer or simply if number == "TEMPLATE" it is template   
#---------SERIALIZED COLUMNS
# serialize :pending_confirmations, Hash ---------removed this column

#-----------ASSOCIATIONS
  belongs_to :parent
  has_many :approvers, class_name: :ContractApprover, inverse_of: :contract
  has_many :users, through: :approvers

  has_many :contract_contragents, class_name: :ContractContragent, inverse_of: :contract 
  has_many :contragents, through: :contract_contragents
  #has_and_belongs_to_many :contragents ---was in HABT went to hm through
  has_many :attachments, class_name: :ContractAttachment
  has_many :comments, class_name: :ContractComments, inverse_of: :contract

  has_one  :contract_kept_at_confirmation, as: :confirmable
  has_many :confirmations, as: :confirmable
  has_many :pending_confirmations, -> {where('confirmations.confirmed > 0')}, as: :confirmable, class_name: :Confirmation

#-----------ASSOCIATIONS' SCOPES
  def executor
    if approvers.loaded?
      (approvers.select { |c| c.is_executor }).first
    else
      approvers.where(contract_approvers: {is_executor: 't'}).first
    end
  end

#------------SERVICE METHODS
        #-----------CONTRACT|CONTRACTKEPTATCONFIRMATION
  def kept_at_confirmation_requested?
    if contract_kept_at_confirmation.nil?
      false
    else
      true
    end
  end

#----------NESTED ATTRIBUTES 
  accepts_nested_attributes_for :approvers, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :contract_kept_at_confirmation, allow_destroy: true
  #accepts_nested_attributes_for :contragents, allow_destroy: true

  accepts_nested_attributes_for :contract_contragents, allow_destroy: true, reject_if: proc {|o| o['contragent_id'].blank?}
  
#----------VALIDATIONS
  validates_presence_of :approval_counter, on: :create
  validate :signed_by_company_to_be_a_valid_date, if: (Proc.new do |c| 
    (c.validation_options[:set_signed_by_company] == true) unless defined?(c.validation_options[:set_signed_by_company]).nil?
  end)
  validate :sent_to_contragent_to_be_a_valid_date, if: (Proc.new do |c|
    (c.validation_options[:set_sent_to_contragent] == true) unless defined?(c.validation_optionsc.validation_options[:set_sent_to_contragent]).nil?
  end)
  validate :recieved_from_contragent_to_be_a_valid_date, if: (Proc.new do |c|
    (c.validation_options[:set_recieved_from_contragent] == true) unless defined?(c.validation_options[:set_recieved_from_contragent]).nil?
  end)
  validate :inclusion_of_at_least_one_executor, on: :create
  validates_presence_of :contract_contragents, unless: (Proc.new do |c|
    c.number == "TEMPLATE"
  end), on: :create
#----------VALIDATION OPTIONS

  attr_accessor :validation_options

 # private :signed_by_company_to_be_a_valid_time
  def signed_by_company_to_be_a_valid_date
    is_valid_date?(signed_by_company)
  end
  def sent_to_contragent_to_be_a_valid_date
    is_valid_date?(sent_to_contragent)
  end
  def recieved_from_contragent_to_be_a_valid_date
    is_valid_date?(recieved_from_contragent)
  end
  def is_valid_date?(attribute)
    errors.add(attribute.to_sym, 'must b a valid date') if (Date.parse(attribute) rescue return false)
  end

#------------VALIDATION METHODS
  def inclusion_of_at_least_one_executor  
    executor = self.approvers.select {|a| a.is_executor != nil}
    return false if executor.blank?
=begin
    counter = 0
    approvers.each do |a|
      if a.is_executor != nil
        counter += 1
      end
    end
    if counter < 1
      errors.add :base, "no executor chosen"
    end
=end
  end

  
#-----------SCOPES

#-----------CALLBACKS
 

#-----------SCOPELIKE METHODS (WTF?)
  def self.unapproved_contracts_for_user(user_id)
    Contract.joins(:approvers).
      select("contracts.id, contracts.number, contracts.subject, 
      contract_approvers.approved as u_approved, contract_approvers.notified as notified,
      contract_approvers.visited as visited").
      where(contract_approvers:{approved:nil, user_id: user_id})
  end

#--------methods
  #approves contract
  def approve!(approver)
    #TODO: refactor using callbacks on both contract and ContractApprovers models 
    raise "CONTRACT#APPROVE!" if (contract_approver_instance = approvers.where(user_id: approver.id, approved: nil).first).nil?   
    transaction do
      begin
        contract_approver_instance.approved = Time.now
        contract_approver_instance.save!
        self.decrement!(:approval_counter)
        if self.approval_counter == 0
          self.approved = Time.now
          save!
        end
        unless UserNotification.notify_users_of_contract_approval_by_all(
                self.id, self.number, (self.approval_counter == 0) ?  'all' : contract_approver_instance.user.name, contract_approver_instance.user)
         raise 'notification error'
        end
      #rescue 
        #return false
      end
    end
    contract_approver_instance.approved
  end
  #update_with_confirmation ({params}, type), not to oerride default update 
  #this methods updates contract, with nested attrs for confirmation, confirmation status and so on
  #and triggers that callack hell for saving confirmation of type: type arg
  def update_with_confirmation(params, type = {})
    transaction do
      #self.pending_confirmations ||= {}
      #self.pending_confirmations[type[:type]] = true ------removed this column
      self.update(params)
    end
  end
#=========CALLBACK METHODS

#-------------FROM OBSERVABLES

def contract_kept_at_confirmed(keeper_id)
  self.update(kept_at: keeper_id) 
end

def on_project_upload(attachment_instance)  
    self.approvers.each do |a|
      a.log ||= {}
      a.log[:previously_approved] ||= [] 
      a.log[:previously_approved] << a.approved unless a.approved == nil
      a.approved = nil
      a.notified = nil
    end
    self.approval_counter = self.approvers.size
    self.approved = nil
    self.save
end
 protected
 
end










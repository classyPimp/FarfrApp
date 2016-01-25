class User < ActiveRecord::Base
  
#SCHEMA:
=begin
      t.string :password_digest
      t.string :email
      t.string :name
      t.timestamps null: false
      :remember_digest, :string
=end
#-------ASSOSIATIONS
  has_many :approvers, class_name: :ContractApprover, inverse_of: :user
  has_many :contracts, through: :approvers
  has_many :contract_comments, inverse_of: :user
  has_many :comments, inverse_of: :user
  has_many :user_notifications, inverse_of: :user_notifications

  has_many :confirmation_initiatiators, class_name: :confirmation, foreign_key: :initiator
  has_many :confirmation_confirmators, class_name: :confirmation_status

  has_many :confirmations, class_name: '::ConfirmationStatus'
  has_many :pending_confirmations, ->{where(confirmed: nil)}, class_name: '::ConfirmationStatus'

  has_many :assignees
  has_many :assignments, through: :assignees

  #scoped associations
  has_many :uncompleted_assignments, through: :assignees, class_name: 'Assignment'


#--------VALIDATIONS  
  validates :password, length: {minimum: 4}
  validates :password_confirmation, presence: true
  validates :email, email: true
  validates_uniqueness_of :email
  attr_accessor :remember_token
#---------SCOPES
  
#---------INSTANCE SCOPES
  def unapproved
    approvers.where(approved: nil)
  end
#--------methods
  #sets approved provided contract
  # e.g. user.first.approve(Contract.first)
  # => contract.appoved: :timestamp
  #else error added to user instance
  def approve(contract)
    contract_id = contract.kind_of?(Contract) ? contract.id : contract.to_i
    contract = self.approvers.find_by(contract_id: contract_id) 
    if contract.approved == nil
      (contract.approved = Time.now; contract.save) 
      contract
    else
      errors.add(:base, "Contract already approved!")
      self
    end

  end

#--------AUTHENTICATION METHODS
  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))    
  end

  def authenticated_via_remember?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget_remember_token
    update_attribute(:remember_digest, nil)
  end
end

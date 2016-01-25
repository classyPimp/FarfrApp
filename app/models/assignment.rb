class Assignment < ActiveRecord::Base


#--------------MODULE INCLUSIONS
  include Wisper::Publisher
  
#----------CCONSTANTS
  REPORT_FORMS = ['written', 'verbal', 'in file']
#----------ASSOCIATIONS
  belongs_to :assignable, polymorphic: true
  has_many :assignees
  has_many :attachments, as: :attachable
  belongs_to :user
  has_many :comments, as: :commentable


#----------ASSOCIATION SCOPES
  

#-----------ACCEPTS NESTED ATTRIBUTES FOR
  accepts_nested_attributes_for :assignees, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc {|attributes| attributes[:attachment].blank?} 

#-----------SEELCT ON ASSOCIATION

#-----------VALIDATIONS

  validates_presence_of :user_id, :assignment_details, :short_description, :report_form, :assignees

#-----------CALLBACKS
  after_create :assignment_was_created
  after_update :completion_was_confirmed, if: Proc.new {|o| o.completion_confirmed_was.blank? && o.completion_confirmed != nil}
#----------CALLBACK METHODS
  #--------publishing
  def assignment_was_created
    UserNotification.on_confirmation(self, {subject: 'assignment:created'})    
  end
  def completion_was_confirmed
    #Assignee.completion_was_confirmed(self)
    UserNotification.on_confirmation(self, {subject: 'assignment:completion_confirmed'})
  end
end 

class Attachment < ActiveRecord::Base

#-------------ASSOCIATIONS
  belongs_to :attachable, polymorphic: true
  has_attached_file :attachment,
                    :url => '/:class/:attachment/:id_partition/:style/:filename.:extension',
                    :path => ':rails_root/assets/attachments/:class/:attachment/:id_partition/:style/:filename.:extension'
  has_many :comments, as: :commentable
#-------------VALIDATIONS
  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment, content_type: ["application/pdf","application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"], message: "only PDF EXCELL WORD or TEXT file-types allowed"
#------------CALLBACKS
  after_create :assignee_filed_report, if: Proc.new {|o| o.attachable_type == 'Assignee'}


#------------CALLBACK METHODS
  #-----notifiers
  def assignee_filed_report
    UserNotification.on_confirmation(self, {subject: 'assignee:report_filed'})
  end
end

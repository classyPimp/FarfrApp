class ContractAttachment < ActiveRecord::Base
=begin
  create_table "contract_attachments", force: :cascade do |t|
    t.integer  "contract_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "description"
    t.boolean  "is_final"
    t.boolean  "is_scan"
  end
=end
  belongs_to :contract, inverse_of: :attachments
  has_attached_file :document,
                    :url => '/:class/:attachment/:id_partition/:style/:filename.:extension',
                    :path => ':rails_root/assets/docs/:class/:attachment/:id_partition/:style/:filename.:extension'
  validates_attachment_presence :document
  validates_attachment_content_type :document, content_type: ["application/pdf","application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"], message: "only PDF EXCELL WORD or TEXT file-types allowed", unless: (Proc.new do |a|
                a.is_project == true
             end)
  validates_attachment_content_type :document, content_type: ["application/x-rar-compressed", "application/zip", "application/x-gzip", "application/octet-stream"], message: "Project files shall be uploaded in zip/rar archive", if: (Proc.new do |a|
        a.is_project == true
    end)
  validates_attachment_content_type :document, content_type: ["application/pdf"], message: "only PDF allowed for sugned scans", if: (Proc.new do |a|
    a.is_scan != nil
  end)

#----------CALLBACKS
  before_create :alter_name
  before_update :set_right_value_to_is_final
  after_create :on_is_project_uploaded, if: (Proc.new do |o|
      if (self.is_project == true) && self.contract.attachments().size > 1
        true
      end
    end)

#----------CALLBACK METHODS
  def alter_name
    extension = File.extname(document_file_name).downcase
    prepared_name = self.contract.number.gsub(/[^A-Za-z0-9А-Яа-я]+/, '-').gsub('/', '-')
    self.document.instance_write(:file_name, "#{prepared_name}_#{Time.now.to_formatted_s(:number)}#{extension}")
  end

  def set_right_value_to_is_final
    if is_final == 0 || is_final == '0' || is_final == false
      is_final = ''
    end
  end

  def on_is_project_uploaded
    UserNotification.on_confirmation(self)
    #ContractApprover.on_project_upload(self)
    self.contract.on_project_upload(self)   
  end
end
 
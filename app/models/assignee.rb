class Assignee < ActiveRecord::Base


#---------ASSOCIATIONS
  belongs_to :user
  belongs_to :assignment
  has_many :attachments, as: :attachable
  #---------associations with scopes
  belongs_to :uncompleted_assignment, -> {where(completion_confirmed: nil)}, class_name: :Assignment, foreign_key: :assignment_id

#----------ACCEPTS NESTED ATTRIBUTES
  accepts_nested_attributes_for :attachments
#---------CLASS METHODS

  def self.set_user_notified(user)
    self.where(user_id: user.id, notified: nil).update_all({notified: Time.now})
  end


#-----------ON PUBLISHED EVENTS
=begin
  def self.completion_was_confirmed(assignment)
    self.where(assignment_id: assignment.id).update_all(completed: assignment.completion_confirmed)
  end
=end
end
 
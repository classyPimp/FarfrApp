class Comment < ActiveRecord::Base

#--------ASSOCIATIONS
  belongs_to :commentable, polymorphic: true
  belongs_to :user, inverse_of: :comments
  has_many :attachments, as: :attachable
end

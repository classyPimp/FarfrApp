json.array!(@comments) do |comment|
  json.extract! comment, :user_id, :body, :created_at, :updated_at, :id,
                :parent_id, :parent_node
  json.user_name comment.user.name              
  json.url comment_url(comment.id)
end



json.array!(@comments) do |comment|
  json.extract! comment, :user_id, :body, :created_at, :updated_at, :id,
                :parent_id, :parent_node, :satisfied, :read, :log, :claims
  json.user_name comment.user.name              
  json.url contract_contract_comment_url(comment.contract_id, comment.id)
end



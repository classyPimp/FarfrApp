#right now it's unused create renders simply json: {status: 200}
json.contract_comment do 
  json.body @comment.body
  json.parent @comment.parent_id
  json.parent_node @comment.parent_node
  json.user_id @comment.user_id
  json.satisfied @comment.satisfied
  json.read @comment.read
  json.user_name @comment.user.name
  json.id @comment.id
  json.created_at @comment.created_at
  json.updated_at @comment.updated_at
end
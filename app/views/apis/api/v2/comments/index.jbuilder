json.comments @comments do |comment|
  json.partial! 'api/v2/comments/comment', comment: comment
end

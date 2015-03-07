json.message_boards @message_boards do |message_board|
  json.partial! 'api/v1/message_boards/message_board', message_board: message_board

  json.comments message_board.comments do |comment|
    json.partial! 'api/v1/comments/comment', comment: comment
  end

  json.comment_count message_board.comments.count
end

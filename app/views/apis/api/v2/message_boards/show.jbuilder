json.message_board do
  json.partial! 'api/v2/message_boards/message_board', message_board: @message_board
end

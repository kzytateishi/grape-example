module API
  module V2
    class Comments < Grape::API
      helpers do
        # Strong Parametersの設定
        def comment_params
          ActionController::Parameters.new(params).permit(:body)
        end

        def set_message_board
          @message_board = MessageBoard.find(params[:message_board_id])
        end

        def set_comment
          @comment = @message_board.comments.find(params[:id])
        end

        # パラメータのチェック
        params :attributes do
          requires :body, type: String, desc: "MessageBoard body."
        end

        # パラメータのチェック
        params :message_board_id do
          requires :message_board_id, type: Integer, desc: "MessageBoard id."
        end

        # パラメータのチェック
        params :id do
          requires :id, type: Integer, desc: "MessageBoard id."
        end
      end

      resource :message_boards do
        params do
          use :message_board_id
        end

        route_param :message_board_id do
          resource :comments do
            desc 'GET /api/v2/message_boards/:message_board_id/comments'
            get '/', jbuilder: 'api/v2/comments/index' do
              set_message_board
              @comments = @message_board.comments
            end

            desc 'POST /api/v2/message_boards/:message_board_id/comments'
            params do
              use :attributes
            end
            post do
              set_message_board
              @message_board.comments.create(comment_params)
            end

            desc "DELETE /api/v2/message_boards/:message_board_id/comments/:id"
            params do
              use :id
            end
            delete '/:id' do
              set_message_board
              set_comment
              @comment.destroy
            end
          end
        end
      end
    end
  end
end

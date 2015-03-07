module API
  module V2
    class Base < Grape::API
      format :json
      default_format :json

      # for Grape::Jbuilder
      formatter :json, Grape::Formatter::Jbuilder

      prefix :api # /apiというパスになる
      version 'v2', using: :path # /api/v2というパスになる

      # 例外ハンドル 404
      rescue_from ActiveRecord::RecordNotFound do |e|
        rack_response({ message: e.message, status: 404 }.to_json, 404)
      end

      # 例外ハンドル 400
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        rack_response e.to_json, 400
      end

      # 例外ハンドル 500
      rescue_from :all do |e|
        if Rails.env.development?
          raise e
        else
          error_response(message: "Internal server error", status: 500)
        end
      end

      mount V2::MessageBoards
      mount V2::Comments
    end
  end
end

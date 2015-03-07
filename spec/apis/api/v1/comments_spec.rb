require 'rails_helper'

RSpec.describe API::V1::Comments, type: :request do
  let(:message_board) { FactoryGirl.create(:message_board) }

  describe 'GET /api/v1/message_boards/:message_board_id/comments' do
    it 'responds successfully' do
      FactoryGirl.create_list(:comment, 2, message_board_id: message_board.id)
      get "/api/v1/message_boards/#{message_board.id}/comments"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe 'POST /api/v1/message_boards/:message_board_id/comments' do
    let(:path) { "/api/v1/message_boards/#{message_board.id}/comments" }
    let(:attributes) { FactoryGirl.attributes_for(:comment) }

    describe 'validations' do
      context 'when title not exist in params' do
        let(:attributes) { FactoryGirl.attributes_for(:comment).except(:body) }
        it  do
          post path, attributes

          expect(response).not_to be_success
          expect(response.status).to eq(400)
        end
      end
    end

    it 'responds successfully' do
      post path, attributes

      expect(response).to be_success
      expect(response.status).to eq(201)
    end

    it 'creates a new Comment' do
      expect {
        post path, attributes
      }.to change(Comment, :count).by(1)
    end
  end

  describe 'DELETE /api/v1/message_boards/:message_board_id/comments/:id' do
    let(:comment) { FactoryGirl.create(:comment, message_board_id: message_board.id) }

    before { comment }

    it 'deletes a Comment' do
      expect {
        delete "/api/v1/message_boards/#{message_board.id}/comments/#{comment.id}"
      }.to change(Comment, :count).by(-1)
    end
  end
end

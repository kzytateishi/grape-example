require 'rails_helper'

RSpec.describe API::V2::MessageBoards, type: :request do
  describe 'GET /api/v2/message_boards' do
    it 'responds successfully' do
      FactoryGirl.create_list(:message_board, 2)
      get '/api/v2/message_boards'
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe 'POST /api/v2/message_boards' do
    let(:path) { '/api/v2/message_boards' }
    let(:attributes) { FactoryGirl.attributes_for(:message_board) }

    describe 'validations' do
      context 'when title not exist in params' do
        let(:attributes) { FactoryGirl.attributes_for(:message_board).except(:title) }
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

    it 'creates a new MessageBoard' do
      expect {
        post path, attributes
      }.to change(MessageBoard, :count).by(1)
    end
  end

  describe 'GET /api/v2/message_boards/:id' do
    let(:message_board) { FactoryGirl.create(:message_board) }

    it 'responds successfully' do
      get "/api/v2/message_boards/#{message_board.id}"
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT /api/v2/message_boards/:id' do
    let(:message_board) { FactoryGirl.create(:message_board) }
    let(:attributes) { FactoryGirl.attributes_for(:message_board, title: changed_title) }
    let(:changed_title) { 'changed title' }
    let(:path) { "/api/v2/message_boards/#{message_board.id}" }

    describe 'validations' do
      context 'when title not exist in params' do
        let(:attributes) { FactoryGirl.attributes_for(:message_board).except(:title) }
        it  do
          put path, attributes

          expect(response).not_to be_success
          expect(response.status).to eq(400)
        end
      end
    end

    it 'responds successfully' do
      put path, attributes
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'updates MessageBoard' do
      put path, attributes
      expect(message_board.reload.title).to eq(changed_title)
    end
  end

  describe 'DELETE /api/v2/message_boards/:id' do
    let(:message_board) { FactoryGirl.create(:message_board) }

    it 'deletes a MessageBoard' do
      message_board
      expect {
        delete "/api/v2/message_boards/#{message_board.id}"
      }.to change(MessageBoard, :count).by(-1)
    end
  end
end

require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "first message between two users" do
    it "only creates one message thread" do
      user_2 = create(:user)
      expect do
        post messages_path, headers: { 'Accept': 'text/vnd.turbo-stream.html' }, params: {
          user_id: user_2.id,
          message: {
            body: "new message"
          }
        }
      end.to change { MessageThread.count }.by(1)
    end

    it "only creates one message" do
      user_2 = create(:user)
      expect do
        post messages_path, headers: { 'Accept': 'text/vnd.turbo-stream.html' }, params: {
          user_id: user_2.id,
          message: {
            body: "new message"
          }
        }
      end.to change { Message.count }.by(1)
    end
  end

  describe "second message between two users" do
    let(:user_2) { create(:user) }
    let(:message_thread) { create(:message_thread) }

    before do
      user.message_threads << message_thread
      user_2.message_threads << message_thread
      create(:message, user: user, body: "test", message_thread: message_thread)
    end

    it "only creates one message on top of existing message" do
      expect do
        post messages_path, headers: { 'Accept': 'text/vnd.turbo-stream.html' }, params: {
          user_id: user_2.id,
          message: {
            body: "new message"
          }
        }
      end.to change { Message.count }.from(1).to(2)
      expect(Message.last.message_thread).to eq(message_thread)
    end
  end
end

require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "first message between the two users" do
    it "only creates one channel" do
      user_2 =  create(:user)

      expect do
        post messages_path, headers: { 'Accept': 'text/vnd.turbo-stream.html' }, params: {
          user_id: user_2.id,
          message: {
            body: "new message"
          }
        }
      end.to change { Channel.count }.by(1)
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

  describe "second message between the two users" do
    let(:user_2) { create(:user) }
    let(:channel) { create(:channel) }

    before do
      user.channels << channel
      user_2.channels << channel

      create(:message, sender: user, body: "test", channel: channel)
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

      expect(Message.last.channel).to eq(channel)
    end
  end
end

require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET index" do
    it "succeeds" do
      get notifications_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE destroy" do
    it "deletes a record" do
      notification = create(:notification)
      expect do
        delete notification_path(notification), headers: { 'Accept': 'text/vnd.turbo-stream.html' }
      end.to change { Notification.count }.by(-1)
    end
  end
end

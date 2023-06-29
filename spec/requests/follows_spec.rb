require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  before { sign_in user_1 }

  describe "POST create" do
    it "creates a new following" do
      expect do
        post user_follows_path(user_1), params: {
          followed_id: user_2.id
        }
      end.to change { Follow.count }.by(1)

      expect(response).to redirect_to user_path(user_2)
    end
  end

  describe "DELETE destroy" do
    it "deletes an existing following" do
      follow = create(:follow, follower: user_1, followed: user_2)

      expect do
        delete user_follow_path(user_1, follow)
      end.to change { Follow.count }.by(-1)

      expect(response).to redirect_to user_path(user_2)
    end
  end
end

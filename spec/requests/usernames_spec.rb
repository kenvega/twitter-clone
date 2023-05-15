require 'rails_helper'

RSpec.describe "Usernames", type: :request do

  let(:user) { create(:user) }

  before { sign_in user }

  describe "Get new" do
    context "when user is logged in" do
      it "responds with the view" do
        user = create(:user)
        sign_in user
        get new_username_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not logged in" do
      it "responds with redirect" do
        get new_username_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end

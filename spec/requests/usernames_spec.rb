require 'rails_helper'

RSpec.describe "Usernames", type: :request do
  let(:user) { create(:user, username: nil) }

  describe "GET #new" do
    context "with a logged in user" do
      before { sign_in user }

      it "returns a successful response" do
        get new_username_path
        expect(response).to have_http_status(:success)
      end
    end

    context "with no logged in user" do
      it "redirects to the login page" do
        get new_username_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "PUT #update" do
    context "with a logged in user" do
      before { sign_in user }

      it "updates the username and redirects to the dashboard" do
        expect do
          put username_path(user), params: {
            user: {
              username: "foobar"
            }
          }
        end.to change { user.reload.username }.from(nil).to("foobar")

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  before { sign_in user_1 }

  describe "GET show" do
    it "succeeds seeing other profiles" do
      get user_path(user_2)
      expect(response).to have_http_status(:success)
    end

    it "redirects if viewing their own profile" do
      get user_path(user_1)
      expect(response).to redirect_to profile_path
    end
  end
end

require 'rails_helper'

RSpec.describe "Retweets", type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  before { sign_in user }

  describe "POST create" do
    it "creates a new Retweet" do
      expect do
        post tweet_retweets_path(tweet)
      end.to change { Retweet.count }.by(1)
    end
  end

  describe "DELETE destroy" do
    it "deletes a Retweet" do
      retweet = create(:retweet, user: user, tweet: tweet)
      expect do
        delete tweet_retweet_path(tweet, retweet)
      end.to change { Retweet.count }.by(-1)
    end
  end
end

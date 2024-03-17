require 'rails_helper'

RSpec.describe "ReplyTweets", type: :request do
  let(:user) { create(:user) }
  let!(:parent_tweet) { create(:tweet) }

  before do
    sign_in user
    allow(CreateTweetActivityJob).to receive(:perform_later)
  end

  describe "POST create" do
    it "creates a new tweet" do
      expect do
        post tweet_reply_tweets_path(parent_tweet), params: { tweet: { body: "new tweet body" } }
      end.to change { Tweet.count }.by(1)
      expect(response).to redirect_to(dashboard_path)
    end

    it "queues the CreateTweetActivityJob" do
      post tweet_reply_tweets_path(parent_tweet), params: { tweet: { body: "new tweet body" } }

      expect(CreateTweetActivityJob).to have_received(:perform_later).with(activity_creator: user, tweet: parent_tweet, activity: 'replied')
    end
  end
end

require 'rails_helper'

RSpec.describe "Retweets", type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  before do
    sign_in user
    allow(CreateTweetActivityJob).to receive(:perform_later)
  end

  describe "POST create" do
    it "creates a new Retweet" do
      expect do
        post tweet_retweets_path(tweet)
      end.to change { Retweet.count }.by(1)
    end

    it "queues the CreateTweetActivityJob" do
      post tweet_retweets_path(tweet)

      expect(CreateTweetActivityJob).to have_received(:perform_later).with(activity_creator: user, tweet: tweet, activity: 'retweeted')
    end
  end

  describe "DELETE destroy" do
    it "deletes a Retweet" do
      retweet = create(:retweet, user: user, tweet: tweet)
      expect do
        delete tweet_retweet_path(tweet, retweet)
      end.to change { Retweet.count }.by(-1)
    end

    # TODO: should create a case where TweetActivities related to a retweeted tweet are deleted once the user unretweets a tweet
    #        similar to what we have in spec/requests/likes_spec.rb
  end
end

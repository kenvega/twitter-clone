require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  before { sign_in user }

  describe "POST create" do
    it "creates a new like" do
      expect do
        post tweet_likes_path(tweet)
      end.to change { Like.count }.by(1)
    end

    it "creates a new notification" do
      expect do
        post tweet_likes_path(tweet)
      end.to change { Notification.count }.by(1)
    end
  end

  describe "DELETE destroy" do
    it "deletes a like" do
      like = create(:like, user: user, tweet: tweet)
      expect do
        delete tweet_like_path(tweet, like)
      end.to change { Like.count }.by(-1)
    end

    it "deletes a tweet activity" do
      like = create(:like, user: user, tweet: tweet)
      # this activity assumes that 'tweet.user' is following 'user'. TODO: this test needs improvement
      tweet_activity = create(:tweet_activity, activity_viewer: tweet.user, activity_creator: user, tweet: tweet, activity: 'liked')
      expect do
        delete tweet_like_path(tweet, like)
      end.to change { TweetActivity.count }.by(-1)
    end
  end
end

require 'rails_helper'

RSpec.describe "Likes", type: :request do
  # user1 is being followed by user2 and user3, and then user1 likes a tweet from user4
  #   that way user3 and user4 should see that tweet liked

  let(:user1) { create(:user) }

  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:user4) { create(:user) }

  let(:tweet) { create(:tweet, user: user4) }

  let(:follow1) { create(:follow, follower: user2, followed: user1) }
  let(:follow2) { create(:follow, follower: user3, followed: user1) }

  before { sign_in user1 }

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
      like = create(:like, user: user1, tweet: tweet)
      expect do
        delete tweet_like_path(tweet, like)
      end.to change { Like.count }.by(-1)
    end

    it "deletes a tweet activity" do
      like = create(:like, user: user1, tweet: tweet)
      # this activity assumes that 'tweet.user' is following 'user'. TODO: this test needs improvement
      tweet_activity = create(:tweet_activity, activity_viewer: tweet.user, activity_creator: user1, tweet: tweet, activity: 'liked')
      expect do
        delete tweet_like_path(tweet, like)
      end.to change { TweetActivity.count }.by(-1)
    end
  end
end

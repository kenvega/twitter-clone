require 'rails_helper'

RSpec.describe "Likes", type: :request do
  # user1 is following user4
  # user1 is being followed by user2 and user3
  # and then user1 likes a tweet from user4
  # that way user2 and user3 should see that tweet liked (2 tweet activities were created)

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:user4) { create(:user) }

  let(:tweet_from_user2) { create(:tweet, user: user2) }
  let(:tweet_from_user3) { create(:tweet, user: user3) }
  let(:tweet_from_user4) { create(:tweet, user: user4) }

  let(:follow1) { create(:follow, follower: user1, followed: user4) }
  let(:follow2) { create(:follow, follower: user2, followed: user1) }
  let(:follow3) { create(:follow, follower: user3, followed: user1) }

  before do
    sign_in user1
    allow(CreateTweetActivityJob).to receive(:perform_later)
  end

  describe "POST create" do
    it "creates a new like" do
      expect do
        post tweet_likes_path(tweet_from_user4)
      end.to change { Like.count }.by(1)
    end

    it "creates a new notification" do
      expect do
        post tweet_likes_path(tweet_from_user4)
      end.to change { Notification.count }.by(1)
    end

    it "queues the ViewTweetJob" do
      post tweet_likes_path(tweet_from_user4)

      expect(CreateTweetActivityJob).to have_received(:perform_later).with(activity_creator: user1, tweet: tweet_from_user4, activity: 'liked')
    end
  end

  describe "DELETE destroy" do
    it "deletes a like" do
      like = create(:like, user: user1, tweet: tweet_from_user4)
      expect do
        delete tweet_like_path(tweet_from_user4, like)
      end.to change { Like.count }.by(-1)
    end

    it "deletes a tweet activity" do
      like = create(:like, user: user1, tweet: tweet_from_user4)
      tweet_activity1 = create(:tweet_activity, activity_viewer: user2, activity_creator: user1, tweet: tweet_from_user4, activity: 'liked')
      tweet_activity2 = create(:tweet_activity, activity_viewer: user3, activity_creator: user1, tweet: tweet_from_user4, activity: 'liked')

      # this is another tweet activity not related to the destroy of the like. this tweet activity should not be deleted
      tweet_activity3 = create(:tweet_activity, activity_viewer: user1, activity_creator: user4, tweet: tweet_from_user4, activity: 'tweeted')

      expect do
        delete tweet_like_path(tweet_from_user4, like)
      end.to change { TweetActivity.count }.by(-2)
    end
  end
end

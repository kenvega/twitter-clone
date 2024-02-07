require 'rails_helper'

RSpec.describe "Tweets", type: :request do

  describe "GET show" do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet) }

    before do
      sign_in user
      allow(ViewTweetJob).to receive(:perform_later)
    end

    it "succeeds" do
      get tweet_path(tweet)

      expect(response).to have_http_status(:success)
    end

    it "queues the ViewTweetJob" do
      get tweet_path(tweet)

      expect(ViewTweetJob).to have_received(:perform_later).with(user: user, tweet: tweet)
    end
  end

  describe "POST create" do
    context "when user is not logged in" do
      it "is responds with redirect" do
        post tweets_path, params: { tweet: { body: "new tweet body" } }
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in user
        allow(TweetActivity::TweetedJob).to receive(:perform_later)
      end

      it "creates a new tweet" do
        expect do
          post tweets_path, params: { tweet: { body: "new tweet body" } }
        end.to change { Tweet.count }.by(1)
        expect(response).to redirect_to(dashboard_path)
      end

      it "queues up TweetActivity::TweetedJob" do
        post tweets_path, params: { tweet: { body: "new tweet body" } }
        tweet = Tweet.last
        expect(TweetActivity::TweetedJob).to have_received(:perform_later).with(activity_creator: user, tweet: tweet)
      end
    end
  end

  describe "saving mentions" do
    let (:user) { create(:user) }

    context "when there are no mentions in the body" do
      it "does not create any new mentions" do
        expect do
          Tweet.create(user: user, body: 'mary had a little lamb')
        end.not_to change { Mention.count }
      end
    end

    context "when there are mentions in the body" do
      it "creates new mentions" do
        user = User.create(email: "foo@bar.com", username: "foobar", password: "password")
        expect do
          Tweet.create(user: user, body: "this is a test mention tweet for @foobar")
        end.to change { Mention.count }.by(1)
      end

      it "creates a new notification" do
        user = User.create(email: "foo@bar.com", username: "foobar", password: "password")
        expect do
          Tweet.create(user: user, body: "this is a test mention tweet for @foobar")
        end.to change { Notification.count }.by(1)
      end
    end
  end
end

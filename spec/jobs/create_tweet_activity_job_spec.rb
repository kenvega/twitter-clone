require 'rails_helper'

RSpec.describe CreateTweetActivityJob, type: :job do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }
  let(:tweet_user) { tweet.user }

  it "creates a new tweet activity" do
    tweet_user.followers << user

    expect do
      described_class.new.perform(activity_creator: tweet_user, tweet: tweet, activity: "tweeted")
    end.to change { TweetActivity.count }.by(1)
  end
end

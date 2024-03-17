require 'rails_helper'

RSpec.describe CreateTweetActivityJob, type: :job do
  let(:user1) { create(:user) }
  let(:tweet) { create(:tweet) }
  let(:user2) { tweet.user }

  it "creates a new tweet activity" do
    user2.followers << user1

    expect do
      described_class.new.perform(activity_creator: user2, tweet: tweet, activity: "tweeted")
    end.to change { TweetActivity.count }.by(1)
  end
end

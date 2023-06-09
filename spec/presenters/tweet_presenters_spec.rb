require 'rails_helper'

RSpec.describe TweetPresenter, type: :presenter do
  describe "#humanized_created_at" do
    context "when 24 hours have passed" do
      before do
        travel_to Time.local(2008, 9, 3, 10, 5, 0)
      end

      after do
        travel_back
      end

      it "displays the shortened day format" do
        tweet = create(:tweet)
        tweet.update!(created_at: 2.days.ago)

        expect(TweetPresenter.new(tweet: tweet, current_user: build_stubbed(:user)).humanized_created_at).to eql("Sep 1")
      end
    end

    context "before a full day has passed" do
      it "displays how much time has passed in minutes or hours" do
        tweet = create(:tweet)
        tweet.update! created_at: 2.hours.ago

        expect(TweetPresenter.new(tweet: tweet, current_user: build_stubbed(:user)).humanized_created_at).to eql("about 2 hours")
      end
    end
  end
end

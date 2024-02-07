FactoryBot.define do
  factory :tweet_activity do
    activity_viewer { create(:user) }
    activity_creator { create(:user) }
    tweet
    activity { TweetActivity::ACTIVITIES.sample }
  end
end

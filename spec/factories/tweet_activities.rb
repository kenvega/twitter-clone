FactoryBot.define do
  factory :tweet_activity do
    user
    tweet
    activity { TweetActivity::ACTIVITIES.sample }
  end
end

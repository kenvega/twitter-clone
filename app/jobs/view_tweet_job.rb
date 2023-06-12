class ViewTweetJob < ApplicationJob
  queue_as :default

  def perform(tweet:, user:)
    View.create(tweet: tweet, user: user) unless tweet_viewed_by_user?(tweet: tweet, user: user)
  end

  private

  def tweet_viewed_by_user?(tweet:, user:)
    View.exists?(user: user, tweet: tweet)
  end
end

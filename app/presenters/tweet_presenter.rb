class TweetPresenter
  include ActionView::Helpers::DateHelper

  def initialize(tweet)
    @tweet = tweet
  end

  attr_reader :tweet

  # this will do
  # tweetPresenter.tweet.user when calling tweetPresenter.user
  # tweetPresenter.tweet.body when calling tweetPresenter.body
  # where tweetPresenter is an instance of TweetPresenter
  delegate :user, :body, :likes, to: :tweet

  delegate :display_name, :avatar, :username, to: :user

  def humanized_created_at
    if (Time.zone.now - tweet.created_at) > 1.day
      tweet.created_at.strftime("%b %-d")
    else
      time_ago_in_words(tweet.created_at)
    end
  end
end
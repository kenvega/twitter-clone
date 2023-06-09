class TweetPresenter
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers

  def initialize(tweet:, current_user:)
    @tweet = tweet
    @current_user = current_user
  end

  attr_reader :tweet, :current_user

  # this will do
  # tweetPresenter.tweet.user when calling tweetPresenter.user
  # tweetPresenter.tweet.body when calling tweetPresenter.body
  # where tweetPresenter is an instance of TweetPresenter
  delegate :user, :body, :likes, :likes_count, to: :tweet

  delegate :display_name, :avatar, :username, to: :user

  def humanized_created_at
    if (Time.zone.now - tweet.created_at) > 1.day
      tweet.created_at.strftime("%b %-d")
    else
      time_ago_in_words(tweet.created_at)
    end
  end

  def tweet_like_url
    if tweet_liked_by_current_user?
      tweet_like_path(tweet, current_user.likes.find_by(tweet: tweet))
    else
      tweet_likes_path(tweet)
    end
  end

  def tweet_bookmark_url
    if tweet_bookmarked_by_current_user?
      tweet_bookmark_path(tweet, current_user.bookmarks.find_by(tweet: tweet))
    else
      tweet_bookmarks_path(tweet)
    end
  end

  def turbo_like_data_method
    if tweet_liked_by_current_user?
      "delete"
    else
      "post"
    end
  end

  def turbo_bookmark_data_method
    if tweet_bookmarked_by_current_user?
      "delete"
    else
      "post"
    end
  end

  def like_heart_image
    if tweet_liked_by_current_user?
      "heart-filled.svg"
    else
      "heart-unfilled.svg"
    end
  end

  def bookmark_image
    if tweet_bookmarked_by_current_user?
      "bookmark-filled.svg"
    else
      "bookmark-unfilled.svg"
    end
  end

  def bookmark_text
    if tweet_bookmarked_by_current_user?
      "Bookmarked"
    else
      "Bookmark"
    end
  end

  private

  def tweet_liked_by_current_user
    @tweet_liked_by_current_user ||= current_user.liked_tweet_ids.include?(tweet.id)
  end

  # alias is created because method names ending with question mark cannot be memoized. But it is better to memoize that value in this case
  alias_method :tweet_liked_by_current_user?, :tweet_liked_by_current_user


  def tweet_bookmarked_by_current_user
    @tweet_bookmarked_by_current_user ||= current_user.bookmarked_tweet_ids.include?(tweet.id)
  end

  alias_method :tweet_bookmarked_by_current_user?, :tweet_bookmarked_by_current_user
end
class Tweet < ApplicationRecord
  HASHTAG_REGEX = /(#\w+)/
  MENTIONS_REGEX = /(@\w+)/

  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user

  has_many :retweets, dependent: :destroy
  has_many :retweeted_users, through: :retweets, source: :user

  has_many :views, dependent: :destroy
  has_many :viewed_users, through: :views, source: :user

  belongs_to :parent_tweet, foreign_key: :parent_tweet_id, class_name: "Tweet", inverse_of: :reply_tweets, optional: true, counter_cache: :reply_tweets_count
  has_many :reply_tweets, foreign_key: :parent_tweet_id, class_name: "Tweet", inverse_of: :parent_tweet

  has_many :mentions, dependent: :destroy
  has_many :mentioned_users, through: :mentions # TODO: should we add source: :user here too? like in viewed_users

  has_and_belongs_to_many :hashtags

  validates :body, presence: true, length: { maximum: 280 }

  before_save :parse_and_save_hashtags

  def parse_and_save_hashtags
    matches = body.scan(HASHTAG_REGEX)
    return if matches.empty?

    matches.flatten.each do |tag|
      hashtag = Hashtag.find_or_create_by(tag: tag.delete('#'))
      hashtags << Hashtag.find_or_create_by(tag: tag.delete('#'))
    end
  end

  after_save :parse_and_save_mentions

  def parse_and_save_mentions
    matches = body.scan(MENTIONS_REGEX)
    return if matches.empty?

    matches.flatten.each do |mention|
      mentioned_user = User.find_by(username: mention.delete('@'))
      next if mentioned_user.blank?

      mentions.find_or_create_by(mentioned_user: mentioned_user)
    end
  end
end

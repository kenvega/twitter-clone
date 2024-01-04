class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  # above line about :liked_tweets could actually be like this:
  #   "has_many :tweets, through: :likes"
  # but then "user.tweets" would conflict between the liked tweets and the created tweets by the user
  # that's why this relation needs a different name ("liked_tweets") and for these cases it needs a source

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_tweets, through: :bookmarks, source: :tweet

  has_many :retweets, dependent: :destroy
  has_many :retweeted_tweets, through: :retweets, source: :tweet

  has_many :views
  has_many :viewed_tweets, through: :views, source: :tweet


  has_many :given_follows, foreign_key: :follower_id, class_name: "Follow"
  #           It represents all the Follow instances where the user instance is the follower.
  #           This is a direct relation between User and Follow.
  #           `foreign_key: :follower_id` tells Rails to look for Follow instances where the follower_id column matches this user's ID.
  #           `class_name: 'Follow'` tells Rails that these given_follows are of the Follow class.
  has_many :followed_users, through: :given_follows, source: :followed
  #           It represents the users that the user instance is following.
  #           This is an indirect relationship between User and Follow.
  #             followed_users are connected to the User through the given_follows relationship
  #             Rails first finds all the Follow instances where this user is the follower (using the given_follows relationship)
  #               and then, for each of those Follow instances, gets the followed user.
  #           `source: :followed` tell Rails how to get the followed user from each Follow instance.
  #              this option says that each Follow instance has a `followed` method that returns the followed user


  has_many :received_follows, foreign_key: :followed_id, class_name: "Follow"
  #           It represents all the Follow instances where the user is followed.
  has_many :followers, through: :received_follows, source: :follower
  #           It represents the users that a user is being followed by

  # there is no direct relation between users and follows
  #   example there is no line -> has_many :follows
  #     because we wouldn't know if we refer as instances where user is the follower or the followed

  has_many :messages, foreign_key: :sender_id

  has_many :subscriptions
  has_many :channels, through: :subscriptions

  has_many :sent_notifications, class_name: "Notification", foreign_key: :notifier_id, dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: :notified_id, dependent: :destroy

  has_many :tweet_activities, dependent: :destroy

  has_one_attached :avatar

  validates :username, uniqueness: { case_sensitive: false }, allow_blank: true

  # to make sure the display_name always has a value for users
  before_save :set_display_name, if: -> { username.present? && display_name.blank? }
  def set_display_name
    self.display_name = username.humanize
  end

  def liked_tweet_ids
    @liked_tweet_ids ||= likes.pluck(:tweet_id)
  end

  def bookmarked_tweet_ids
    @bookmarked_tweet_ids ||= bookmarks.pluck(:tweet_id)
  end

  def retweeted_tweet_ids
    @retweeted_tweet_ids ||= retweets.pluck(:tweet_id)
  end
end

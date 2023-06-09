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

end

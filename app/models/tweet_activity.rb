class TweetActivity < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  ACTIVITIES = %w[tweeted liked replied retweeted].freeze

  validates :activity, presence: true, inclusion: { in: ACTIVITIES }
end

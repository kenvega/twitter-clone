class TweetActivity < ApplicationRecord
  belongs_to :activity_viewer, class_name: 'User'
  belongs_to :activity_creator, class_name: 'User'
  belongs_to :tweet

  ACTIVITIES = %w[tweeted liked replied retweeted].freeze

  validates :activity, presence: true, inclusion: { in: ACTIVITIES }
end

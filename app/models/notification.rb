class Notification < ApplicationRecord
  belongs_to :notifier, class_name: "User"
  belongs_to :notified, class_name: "User"
  belongs_to :tweet, optional: true

  ACTIONS = %w[followed-me liked-tweet mentioned-me].freeze

  # meta programming to create methods like followed_me?, liked_tweet?, etc
  ACTIONS.each do |a|
    define_method("#{a.gsub('-', '_')}?") { a == action }
  end

  validates :action, presence: true, inclusion: { in: ACTIONS }
end

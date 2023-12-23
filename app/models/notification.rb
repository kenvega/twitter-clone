class Notification < ApplicationRecord
  belongs_to :notifier, class_name: "User"
  belongs_to :notified, class_name: "User"
  belongs_to :tweet, optional: true

  ACTIONS = %w[followed-me liked-tweet mentioned-me].freeze

  validates :action, presence: true, inclusion: { in: ACTIONS }
end

class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :channel

  validates :body, presence: true
end

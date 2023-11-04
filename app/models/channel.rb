class Channel < ApplicationRecord
  has_many :subscribers
  has_many :users, through: :subscribers

  has_many :messages
end

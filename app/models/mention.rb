class Mention < ApplicationRecord
  belongs_to :tweet
  belongs_to :mentioned_user, class_name: "User"
end

class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", counter_cache: :followed_users_count # if this does not have the class_name option the following error appears => NameError: Rails couldn't find a valid model for Follower association
  belongs_to :followed, class_name: "User", counter_cache: :follower_count

  validates :follower_id, uniqueness: { scope: :followed_id }
end

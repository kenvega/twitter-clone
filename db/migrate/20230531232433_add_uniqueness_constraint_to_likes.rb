class AddUniquenessConstraintToLikes < ActiveRecord::Migration[7.0]
  def change
    # a unique index is needed because the same user cannot like the same tweet more than once
    add_index :likes, [:user_id, :tweet_id], unique: true
  end
end

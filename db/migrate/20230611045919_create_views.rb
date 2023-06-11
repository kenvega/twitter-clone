class CreateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true

      # not sure why this is needed because a user actually can see more than once the same tweet
      # should it count more than once that view too? I think it should. So this key does not make too much sense for now to me
      t.index [:user_id, :tweet_id], unique: true

      t.timestamps
    end
  end
end

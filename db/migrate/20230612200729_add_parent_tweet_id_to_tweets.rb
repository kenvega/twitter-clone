class AddParentTweetIdToTweets < ActiveRecord::Migration[7.0]
  def change
    # setting a foreign key constraint to the table
    # checks if parent_tweet_id exist in the tweets table as a tweet_id too
    add_column :tweets, :parent_tweet_id, :bigint, index: true
    add_foreign_key :tweets, :tweets, column: :parent_tweet_id
  end
end

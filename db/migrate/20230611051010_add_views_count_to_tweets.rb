class AddViewsCountToTweets < ActiveRecord::Migration[7.0]
  def up
    add_column :tweets, :views_count, :integer, null: false, default: 0

    Tweet.find_each do |tweet|
      tweet.update!(views_count: tweet.views.size)
    end
  end

  def down
    remove_column :tweets, :views_count
  end
end

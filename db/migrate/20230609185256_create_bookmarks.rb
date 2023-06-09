class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true

      # added constraint because the same user cannot bookmark the same tweet when it is already bookmarked
      t.index [:user_id, :tweet_id], unique: true

      t.timestamps
    end
  end
end

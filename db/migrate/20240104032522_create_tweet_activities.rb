class CreateTweetActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :tweet_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true
      t.string :activity, null: false

      t.timestamps
    end
  end
end

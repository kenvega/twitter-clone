class CreateTweetActivityJob < ApplicationJob
  queue_as :default

  def perform(activity_creator:, tweet:, activity:)
    # below solution is now in a background job but still will make a lot of insert queries when a user has a lot of followers. best to use a bulk insert with a gem like activerecord-import
    # activity_creator.followers.each do |follower|
    #   TweetActivity.create(activity_viewer: follower, activity_creator: activity_creator, tweet: tweet, activity: 'tweeted')
    # end

    # below solution uses gem activerecord-import to make a single (depends on batch_size) big insert query which is more efficient that a lot of short insert queries
    tweet_activities = activity_creator.followers.map do |follower|
      TweetActivity.new(activity_viewer: follower, activity_creator: activity_creator, tweet: tweet, activity: activity)
    end

    TweetActivity.import tweet_activities, on_duplicate_key_ignore: true, batch_size: 500
  end
end

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # initially we loaded all tweets
    # @tweets = Tweet.includes(user: {avatar_attachment: :blob}).order(created_at: :desc).map do |tweet|
    #   TweetPresenter.new(tweet: tweet, current_user: current_user)
    # end

    # then, we loaded just tweets from people we follow
    # followed_users = current_user.followed_users
    # @tweets = Tweet.includes(user: {avatar_attachment: :blob}).where(user: followed_users).order(created_at: :desc).map do |tweet|
    #   TweetPresenter.new(tweet: tweet, current_user: current_user)
    # end

    # and after that we needed to load the general activities instead of just the tweets
    @tweet_activities = current_user.viewable_tweet_activities.includes(tweet: [user: [:avatar_attachment]], activity_creator: []).order(created_at: :desc).map do |tweet_activity|
      TweetPresenter.new(tweet: tweet_activity.tweet, current_user: current_user, tweet_activity: tweet_activity)
    end
  end
end
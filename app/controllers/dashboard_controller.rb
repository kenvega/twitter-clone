class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # before we loaded all tweets
    # @tweets = Tweet.includes(user: {avatar_attachment: :blob}).order(created_at: :desc).map do |tweet|
    #   TweetPresenter.new(tweet: tweet, current_user: current_user)
    # end

    # for now we will load just tweets from people we follow but these will be soon based on activities
    followed_users = current_user.followed_users
    @tweets = Tweet.includes(user: {avatar_attachment: :blob}).where(user: followed_users).order(created_at: :desc).map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: current_user)
    end
  end
end
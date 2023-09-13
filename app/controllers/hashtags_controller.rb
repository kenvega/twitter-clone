class HashtagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @hashtags = Hashtag.all
  end

  def show
    @hashtag = Hashtag.find(params[:id])

    @tweet_presenters = @hashtag.tweets.includes(:user).order(created_at: :desc).map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: current_user)
    end
  end
end
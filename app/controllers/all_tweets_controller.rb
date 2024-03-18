class AllTweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @all_tweets = Tweet.all.includes(user: { avatar_attachment: :blob }).order(created_at: :desc).map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: current_user)
    end
  end
end
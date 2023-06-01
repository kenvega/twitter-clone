class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @tweets = Tweet.includes(:likes, user: { avatar_attachment: :blob }).order(created_at: :desc).map { |tweet| TweetPresenter.new(tweet) }
  end
end
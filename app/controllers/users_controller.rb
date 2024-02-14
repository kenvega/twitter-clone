class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    # redirect to profile path if user to show is currently logged in user
    redirect_to profile_path if params[:id].to_i == current_user.id

    @current_profile_user = User.find(params[:id])
    @tweet_presenters = @current_profile_user.tweets.order(created_at: :desc).map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: @current_profile_user)
    end
  end
end
class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_profile_user

  def show
    set_tweet_presenters
    render "users/show"
  end

  def update
    @current_profile_user.update(user_params[:password].blank? ? user_params.except(:password) : user_params)

    set_tweet_presenters

    respond_to do |format|
      format.html { redirect_to profile_path }
      format.turbo_stream
    end
  end

  private

  def set_current_profile_user
    @current_profile_user = current_user
  end

  def set_tweet_presenters
    @tweet_presenters = @current_profile_user.tweets.map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: @current_profile_user)
    end
  end

  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :bio, :location, :avatar, :profile_url)
  end
end
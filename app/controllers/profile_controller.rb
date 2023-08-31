class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @current_profile_user = current_user
    @tweet_presenters = @current_profile_user.tweets.map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: @current_profile_user)
    end
    render "users/show"
  end

  def update
    current_user.update(user_params[:password].blank? ? user_params.except(:password) : user_params)
    respond_to do |format|
      format.html { redirect_to profile_path }
      format.turbo_stream
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :bio, :location, :profile_url)
  end
end
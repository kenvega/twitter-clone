class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.create(tweet: tweet)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
  end

  private

  def tweet
    @tweet ||= Tweet.find(params[:tweet_id])
  end
end
class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.create(tweet: tweet)

    Notification.create(notified: tweet.user, notifier: current_user, action: "liked-tweet", tweet: tweet)

    CreateTweetActivityJob.perform_later(activity_creator: current_user, tweet: tweet, activity: 'liked')

    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.turbo_stream
    end
  end

  def destroy
    @like = tweet.likes.find(params[:id])
    @like.destroy

    # TODO: this might need a job too like CreateTweetActivityJob
    # when disliking destroy all tweet activities related to that tweet created by the user who liked that tweet
    TweetActivity.where(activity_creator: current_user, tweet: tweet, activity: 'liked').destroy_all

    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.turbo_stream
    end
  end

  private

  def tweet
    @tweet ||= Tweet.find(params[:tweet_id])
  end
end
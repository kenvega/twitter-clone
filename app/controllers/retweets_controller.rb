class RetweetsController < ApplicationController
  before_action :authenticate_user!

  def create
    @retweet = current_user.retweets.create(tweet: tweet)

    CreateTweetActivityJob.perform_later(activity_creator: current_user, tweet: tweet, activity: 'retweeted')

    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.turbo_stream
    end
  end

  def destroy
    @retweet = tweet.retweets.find(params[:id])

    TweetActivity.where(activity_creator: current_user, tweet: tweet, activity: 'retweeted').destroy_all

    @retweet.destroy
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
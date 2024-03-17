class TweetsController < ApplicationController
  before_action :authenticate_user!

  def show
    ViewTweetJob.perform_later(tweet: tweet, user: current_user)
    @tweet_presenter = TweetPresenter.new(tweet: tweet, current_user: current_user)
    @reply_tweets_in_presenter = tweet.reply_tweets.includes(user: {avatar_attachment: :blob}).order(created_at: :desc).map do |reply_tweet|
      TweetPresenter.new(tweet: reply_tweet, current_user: current_user)
    end
  end

  def create
    @tweet = Tweet.create(tweet_params.merge(user: current_user))

    # create the activity for the followers of the user that the current user created a tweet

    #   below solution is not efficient because a user might have 1 000 000 followers and then this would generate many insert queries. best is first to make it a background job
    #     current_user.followers.each do |follower|
    #       TweetActivity.create(activity_viewer: follower, activity_creator: current_user, tweet: @tweet, activity: 'tweeted')
    #     end

    #   doing a background job will make the endpoint to create tweets faster by creating the activities for the followers later
    CreateTweetActivityJob.perform_later(activity_creator: current_user, tweet: @tweet, activity: "tweeted")

    #   before we were checking with @tweet.save? but now we can also check with @tweet.persisted?
    if @tweet.persisted?
      respond_to do |format|
        format.html { redirect_to dashboard_path }

        format.turbo_stream
      end
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end

  def tweet
    @tweet ||= Tweet.find(params[:id])
  end
end
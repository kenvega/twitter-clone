class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_follower_and_followed, only: [:create, :destroy]

  def create
    # create the follow
    follow = @follower.given_follows.create(follow_params)

    # create a channel and subscriptions so people you follow you can later message quicker. but don't create any if those users were talking before
    follower_channel_subscriptions = Subscription.where(user: @follower)
    followed_channel_subscriptions = Subscription.where(user: @followed)

    common_channels = follower_channel_subscriptions.pluck(:channel_id) & followed_channel_subscriptions.pluck(:channel_id)
    already_in_conversation = common_channels.any?

    unless already_in_conversation
      channel = Channel.create()
      Subscription.create(user: @follower, channel_id: channel.id)
      Subscription.create(user: @followed, channel_id: channel.id)
    end

    # create notification
    @followed.received_notifications.create(action: "followed-me", notifier: @follower)

    respond_to do |format|
      format.html do
        redirect_to user_path(follow.followed)
      end

      format.turbo_stream
    end
  end

  def destroy
    follow = Follow.find(params[:id])
    follow.destroy

    respond_to do |format|
      format.html { redirect_to user_path(follow.followed) }

      format.turbo_stream
    end
  end

  private

  def set_follower_and_followed
    @followed ||= params[:followed_id] ? User.find(params[:followed_id]) : Follow.find(params[:id]).followed
    @follower ||= params[:follower_id] ? User.find(params[:follower_id]) : Follow.find(params[:id]).follower
  end

  def follow_params
    params.permit(:id, :follower_id, :followed_id)
  end
end
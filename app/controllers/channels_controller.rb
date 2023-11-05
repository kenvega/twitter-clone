class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    # for the conversations that the current user already have
    current_user_subscribed_channel_ids = Subscription.where(user: current_user).pluck(:channel_id)
    @current_user_subscribed_channels = Channel.where(id: current_user_subscribed_channel_ids)

    # for the new conversation the user is about to begin
    if params[:user_id].present?
      @receiver_message_user = User.find(params[:user_id])
    end
  end
end
class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    # for the conversations that the current user already have
    current_user_subscribed_channel_ids = Subscription.where(user: current_user).pluck(:channel_id)
    @current_user_subscribed_channels = Channel.includes(:users, :messages).where(id: current_user_subscribed_channel_ids).order("messages.created_at desc").to_a

    # for the new conversation the user is about to begin
    user_ids_from_subscribed_channels = @current_user_subscribed_channels.map(&:users).flatten.map(&:id).flatten
    is_there_no_channel_for_sender_and_receiver = !user_ids_from_subscribed_channels.include?(params[:receiver_id].to_i)

    if params[:receiver_id].present? && is_there_no_channel_for_sender_and_receiver
      @receiver_message_user = User.find(params[:receiver_id])

      @current_user_subscribed_channels.unshift(Channel.new)
    end
  end
end
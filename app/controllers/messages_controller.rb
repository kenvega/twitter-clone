class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    # to create a message we will check on all subscriptions of the user we are sending a message to
    #  and all subscriptions we have and check if there is a match there to add new messages to that or
    #  to create a new one

    user_to_send_message = User.find(params[:user_id])

    user_to_send_message_subscriptions = Subscription.where(user: user_to_send_message)
    my_subscriptions = Subscription.where(user: current_user)

    user_to_send_message_channels_ids = user_to_send_message_subscriptions.pluck(:channel_id)
    my_channels_ids = my_subscriptions.pluck(:channel_id)

    common_channels_ids = (user_to_send_message_channels_ids & my_channels_ids) # technically there should always be 1 or 0 common channels for a simple 1 to 1 chat system
    it_needs_new_channel = common_channels_ids.empty?

    if it_needs_new_channel
      ActiveRecord::Base.transaction do
         # create an assign a new channel for both user (sender and reciever)
        channel = Channel.create
        user_to_send_message.channels << channel
        current_user.channels << channel

        # create the message
        Message.create(message_params.merge(sender: current_user, channel: channel))
      end
    else
      # find the common channel
      channel = Channel.find(common_channels_ids.first)

      # create a new message with that channel
      Message.create(message_params.merge(sender: current_user, channel: channel))
    end

  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
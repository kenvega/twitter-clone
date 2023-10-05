class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @message_thread = MessageThread.find(params[:message_thread_id])
    @messages = @message_thread.messages
    # @user = @messages.where.not(user: current_user).first.user

    @user = User.find(params[:other_user_id])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    user = User.find(params[:user_id])

    user_message_threads_ids = MessageThreadsUser.where(user: user).pluck(:message_thread_id)
    my_message_thread_ids = MessageThreadsUser.where(user: current_user).pluck(:message_thread_id)

    common_message_thread_ids = user_message_threads_ids & my_message_thread_ids

    if common_message_thread_ids.empty?
      ActiveRecord::Base.transaction do
        message_thread = MessageThread.create
        user.message_threads << message_thread
        current_user.message_threads << message_thread
        @message = Message.create(message_params.merge(user: current_user, message_thread: message_thread))
      end
    else
      message_thread = MessageThread.find(common_message_thread_ids.first)
      @message = Message.create(message_params.merge(user: current_user, message_thread: message_thread))
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
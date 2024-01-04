class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.includes({notifier: [:avatar_attachment]}, :tweet)
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end
end
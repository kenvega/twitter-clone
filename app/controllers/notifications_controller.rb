class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications.includes({notifier: [:avatar_attachment]}, :tweet)
  end
end
class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id].present?
      @new_subscription = User.find(params[:user_id])
    end
  end
end
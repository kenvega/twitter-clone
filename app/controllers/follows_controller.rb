class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    follow = user.given_follows.create(follow_params)

    redirect_to user_path(User.find(follow_params[:followed_id]))
  end

  def destroy
    follow = Follow.find(params[:id])
    follow.destroy

    redirect_to user_path(User.find(follow.followed_id))
  end

  private

  def user
    @user ||= User.find(params[:user_id])
  end

  def follow_params
    params.permit(:followed_id)
  end
end
class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_follower_and_followed, only: [:create, :destroy]

  def create
    follow = @follower.given_follows.create(follow_params)

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
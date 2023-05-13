class UsernamesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :redirect_to_username_form

  def new
  end

  def update
  end

  private

  def username_params
    params.require(:username).permit(:username)
  end
end
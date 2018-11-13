class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.friendly.find(params[:user_id])
    @follow = current_user.follow(@user)
  end

  def destroy
    @user = User.friendly.find(params[:user_id])
    @follow = current_user.unfollow(@user)
  end
end

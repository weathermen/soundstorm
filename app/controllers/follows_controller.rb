class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    @follow = current_user.follow(@user)

    if current_user.follow(@user)
      flash[:notice] = t('.success', user: @user.name)
    else
      flash[:alert] = t('.failure', user: @user.name)
    end

    redirect_to @user
  end

  def destroy
    @user = User.find(params[:user_id])

    if current_user.stop_following(@user)
      flash[:notice] = t('.success', user: @user.name)
    else
      flash[:alert] = t('.failure', user: @user.name)
    end

    redirect_to @user
  end
end

# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find_by!(name: params[:user_id])

    if current_user.follow!(@user)
      flash[:notice] = t('.success', user: @user.name)
    else
      flash[:alert] = t('.failure', user: @user.name)
    end

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :created }
    end
  end

  def destroy
    @user = User.find_by!(name: params[:user_id])

    if current_user.unfollow!(@user)
      flash[:notice] = t('.success', user: @user.name)
    else
      flash[:alert] = t('.failure', user: @user.name)
    end

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :ok }
    end
  end
end

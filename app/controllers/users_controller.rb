class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[activity]

  def show
    @user = User.find_by(name: params[:id])
  end

  def activity
    @user = current_user
  end

  def webfinger
    @user = User.find_by_resource!(params[:resource])

    render json: @user.as_webfinger
  end
end

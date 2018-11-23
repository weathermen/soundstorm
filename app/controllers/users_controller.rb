class UsersController < ApplicationController
  before_action :cache_page
  skip_before_action :doorkeeper_authorize!, only: :show

  def show
    @user = User.find_by!(name: params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user.actor }
    end
  end

  def webfinger
    @user = User.find_by_resource!(params[:resource])

    render json: @user.as_webfinger
  end
end

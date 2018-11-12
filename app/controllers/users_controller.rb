class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[activity]

  def show
    @user = User.find_by(name: params[:id])
  end

  def activity
    @user = current_user
  end

  def webfinger
    resource = params[:resource]
    handle = resource.gsub(/acct:/, '')
    name, host = handle.split('@')

    head :not_found and return unless host == Rails.application.credentials.host

    @user = User.find_by(name: name)
  end
end

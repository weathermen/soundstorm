# frozen_string_literal: true

class UsersController < ApplicationController
  swagger_controller :users, 'User Profiles and Webfinger'

  before_action :cache_page
  before_action :authenticate_user!, only: %i[follow]
  before_action :authorize_admin!, except: %i[show webfinger dashboard]
  skip_before_action :doorkeeper_authorize!, only: %i[show webfinger]

  def new
    @user = User.new
  end

  swagger_api :show do
    summary "View a user's profile"

    param :path, :username, :string, :required, 'URL-safe name of the user'

    response :unauthorized
  end
  def show
    @user = User.includes(:tracks).find_by!(name: params[:id])
    @title = t('.title', user: @user.name)

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user.actor }
    end
  end

  swagger_api :webfinger do
    summary 'Perform a Webfinger request on a User'

    param :query, :resource, :string, :required, 'Webfinger Resource Name'

    response :unauthorized
    response :not_found
  end

  def webfinger
    @user = User.find_by_resource(params[:resource])

    if @user.present?
      render json: @user.as_webfinger
    else
      message = "Couldn't find User from Webfinger resource #{params[:resource]}"
      render json: { error: message }, status: :not_found
    end
  end
end

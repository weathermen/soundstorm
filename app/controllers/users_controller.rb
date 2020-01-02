# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :cache_page
  before_action :authenticate_user!, only: %i[follow]
  before_action :authorize_admin!, except: %i[show webfinger dashboard]
  skip_before_action :doorkeeper_authorize!, only: %i[show webfinger]

  def show
    @user = User.includes(:tracks).find_by!(name: params[:id])
    @title = t('.title', user: @user.name)

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user.actor }
    end
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

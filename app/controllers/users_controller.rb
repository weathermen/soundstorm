# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :cache_page
  before_action :authenticate_user!, only: %i[follow]
  before_action :authorize_admin!, except: %i[show webfinger dashboard]
  skip_before_action :doorkeeper_authorize!, only: :show

  def index
    @query = params[:q] || '*'
    @users = User.search(@query).records
  end

  def new
    @user = User.new
  end

  def show
    @user = User.includes(:tracks).find_by!(name: params[:id])
    @title = t('.title', user: @user.name)

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

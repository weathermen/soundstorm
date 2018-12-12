# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :cache_page
  before_action :authenticate_user!, only: %i[follow]
  before_action :authorize_admin!, except: %i[show webfinger dashboard]
  skip_before_action :doorkeeper_authorize!, only: %i[show webfinger]

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by(name: params[:id])
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

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = t('.success', user: @user.name)
      redirect_to users_path
    else
      errors = @user.errors.full_messages.to_sentence
      flash[:alert] = t('.failure', errors: errors)
      render :new
    end
  end

  def update
    @user = User.find_by(name: params[:id])

    if @user.update(user_params)
      flash[:notice] = t('.success', user: @user.name)
      redirect_to users_path
    else
      errors = @user.errors.full_messages.to_sentence
      flash[:alert] = t('.failure', errors: errors)
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :host,
      :display_name,
      :key_pem,
      :avatar,
      :admin
    )
  end
end

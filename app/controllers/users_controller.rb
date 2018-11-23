class UsersController < ApplicationController
  before_action :cache_page
  before_action :authenticate_user!, only: %i[follow]
  skip_before_action :doorkeeper_authorize!, only: :show

  def show
    @user = User.find_by!(name: params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user.actor }
    end
  end

  def follow
    @user = User.find!(params[:id])
    @follow = current_user.follow(@user)

    respond_to do |format|
      if @follow.persisted?
        flash[:success] = t('.success', user: @user.name)
        format.html { redirect_to user_path(@user) }
        format.json { render json: @follow, status: :created }
      else
        errors = @follow.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', user: user.name, errors: errors)
        format.html { redirect_to user_path(@user) }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  def unfollow
    @user = User.find!(params[:id])
    current_user.unfollow(@user)

    respond_to do |format|
      flash[:success] = t('.success', user: @user.name)
      format.html { redirect_to user_path(@user) }
      format.json { render json: @follow, status: :created }
    end
  end

  def webfinger
    @user = User.find_by_resource!(params[:resource])

    render json: @user.as_webfinger
  end
end

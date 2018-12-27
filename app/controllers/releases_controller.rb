# frozen_string_literal: true

class ReleasesController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  def index
    @releases = Release.all
  end

  def show
    @user = User.find_by(name: params[:user_id])
    @release = @user.releases.find(params[:id])
    @title = "#{@release.name} - #{@user.display_name}"
  end

  def new
    @release = current_user.releases.build
    @released_track = @release.released_tracks.build
    @track = @released_track.build_track
  end

  def edit
    @release = current_user.releases.find(params[:id])
  end

  def create
    @release = current_user.releases.build(create_params)

    respond_to do |format|
      if @release.save
        flash[:notice] = t('.success', name: @release.name)
        format.html { redirect_back fallback_location: [@release.user, @release] }
        format.json { render json: @release, status: :created }
      else
        errors = @release.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)
        format.html { render :new }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @release = current_user.releases.find(params[:id])

    respond_to do |format|
      if @release.update(update_params)
        flash[:notice] = t('.success', name: @release.name)
        format.html { redirect_back fallback_location: [@release.user, @release] }
        format.json { render json: @release, status: :created }
      else
        errors = @release.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)
        format.html { render :new }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @release = current_user.releases.find(params[:id])

    respond_to do |format|
      if @release.destroy
        flash[:notice] = t('.success', name: @release.name)
        format.html { redirect_back fallback_location: @release.user }
        format.json { render json: @release, status: :created }
      else
        errors = @release.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)
        format.html { render :new }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def create_params
    params.require(:release).permit(
      :name,
      :description,
      released_tracks_attributes: [
        :number,
        :_destroy,
        track_attributes: %i[name audio description user_id]
      ]
    )
  end

  def update_params
    params.require(:release).permit(
      :name,
      :description,
      released_tracks_attributes: [
        :id,
        :number,
        :_destroy,
        track_attributes: %i[name user_id description]
      ]
    )
  end
end

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_track, except: :index

  def index
    @likes = current_user.liked_tracks
  end

  def create
    @like = @track.likes.build(user: current_user)

    respond_to do |format|
      if @like.save
        flash[:notice] = t('.success', track: @track.name)

        format.html { redirect_to @track }
        format.json { render json: @like, status: :created }
      else
        errors = @like.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', track: @track.name, errors: errors)

        format.html { redirect_to @track }
        format.json { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = @track.likes.find_by(user: current_user)

    respond_to do |format|
      if @like.destroy
        flash[:notice] = t('.success', track: @track.name)

        format.html { redirect_to @track }
        format.json { render json: @like, status: :created }
      else
        errors = @like.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', track: @track.name, errors: errors)

        format.html { redirect_to @track }
        format.json { head :unprocessable_entity }
      end
    end
  end

  def find_track
    @track = Track.find(params[:track_id])
  end
end

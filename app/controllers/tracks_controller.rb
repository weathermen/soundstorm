# frozen_string_literal: true

class TracksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show listen]
  skip_before_action :doorkeeper_authorize!, only: %i[listen]
  before_action :cache_page, only: :show

  def show
    @user = User.find_by(name: params[:user_id])
    @track = @user.tracks.find(params[:id])
    @title = "#{@track.name} by #{@user.name}"

    respond_to do |format|
      format.html # show.html.haml
      format.mp3 do
        if @track.downloadable?
          send_data @track.audio.download,
            content_type: :mp3,
            filename: @track.filename,
            disposition: params[:download] ? 'attachment' : 'inline'
        else
          head :unauthorized
        end
      end
      format.m3u8 # show.m3u8.erb
    end
  end

  def new
    @track = current_user.tracks.build
  end

  def edit
    @track = current_user.tracks.find(params[:id])
    @title = t('.title', track: @track.name)
  end

  def create
    @track = current_user.tracks.build(new_track_params)

    respond_to do |format|
      if @track.save
        flash[:notice] = t('.success', name: @track.name)

        format.html { redirect_to [@track.user, @track] }
        format.json { render json: @track, status: :created }
      else
        errors = @track.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)

        format.html { render :new }
        format.json { render json: @track, status: :unprocessable_entity }
      end
    end
  end

  def listen
    @user = User.find_by(name: params[:user_id])
    @track = @user.tracks.find(params[:id])
    @listen = @track.listens.create(
      ip_address: request.ip,
      user: current_user
    )

    if @listen.persisted?
      render json: @track.listens_count, status: :created
    else
      render json: @track.listens_count
    end
  end

  def update
    @track = current_user.tracks.find(params[:id])

    respond_to do |format|
      if @track.update(edit_track_params)
        flash[:notice] = t('.success', name: @track.name)

        format.html { redirect_to [current_user, @track] }
        format.json { render json: @track }
      else
        flash[:notice] = t('.failure', errors: @track.errors.full_messages.to_sentence)

        format.html { render :new }
        format.json { render json: { errors: @track.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @track = current_user.tracks.find(params[:id])

    respond_to do |format|
      if @track.destroy
        flash[:notice] = t('.success', name: @track.name)

        format.html { redirect_to current_user }
        format.json { render json: @track }
      else
        flash[:notice] = t('.failure', errors: @track.errors.full_messages.to_sentence)

        format.html { render :new }
        format.json { render json: { errors: @track.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def new_track_params
    params.require(:track).permit(:name, :audio, :description)
  end

  def edit_track_params
    params.require(:track).permit(:name, :description)
  end
end

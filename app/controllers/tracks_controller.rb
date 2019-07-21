# frozen_string_literal: true

class TracksController < ApplicationController
  swagger_controller :tracks, 'Track Management and Uploading'

  before_action :authenticate_user!, except: %i[index show listen]
  before_action :cache_page, only: :show
  before_action :find_variant_from_content_type, only: :show

  skip_before_action :doorkeeper_authorize!, only: %i[show listen]

  swagger_api :show do
    summary "View a track's information"

    param :path, :user_id, :string, :required, 'Username'
    param :path, :id, :string, :required, 'Track Name'

    response :unauthorized
  end
  def show
    @user = User.find_by!(name: params[:user_id])
    @track = @user.tracks.find(params[:id])
    @title = "#{@track.name} by #{@user.name}"

    respond_to do |format|
      format.html     # show.html.haml      - Web Page
      format.m3u8 do  # show.m3u8.erb       - Stream
        @track.listens.create(ip_address: request.ip, user: current_user)

        render :show
      end
      format.json     # show.json.jbuilder  - JSON API Response
      format.xml      # show.xml.builder    - OEmbed API Response
      format.mp3 do  # MP3 File Download
        return head :unauthorized unless @track.downloadable?

        @track.listens.create(ip_address: request.ip, user: current_user)

        send_data @track.audio.download,
          content_type: :mp3,
          filename: @track.filename,
          disposition: 'attachment'
      end
    end
  end

  def new
    @track = current_user.tracks.build
  end

  def edit
    @track = current_user.tracks.find(params[:id])
    @title = t('.title', track: @track.name)
  end

  swagger_api :create do
    summary 'Upload a new track'

    param :form, 'track[name]', :string, :required, 'Name of the track'
    param :form, 'track[audio]', :string, :required, 'Audio file'
    param :form, 'track[description]', :string, :optional, 'Description of the track'
    param :form, 'track[downloadable]', :boolean, :optional, 'Whether the track can be downloaded (default: true)'

    response :unauthorized
    response :unprocessable_entity
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

  swagger_api :update do
    summary 'Edit an existing track'

    param :path, :id, :integer, :required, 'ID of the Track'
    param :form, 'track[name]', :string, :optional, 'Name of the track'
    param :form, 'track[description]', :string, :optional, 'Description of the track'
    param :form, 'track[downloadable]', :boolean, :optional, 'Whether the track can be downloaded'

    response :unauthorized
    response :unprocessable_entity
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

  swagger_api :destroy do
    summary 'Delete a track'

    param :path, :id, :integer, :required, 'ID of the Track'

    response :unauthorized
    response :unprocessable_entity
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

  def variant_request?
    request.content_type.include('+')
  end

  def find_variant_from_content_type
    variant = if request.media_type.include? '+'
      request.media_type.split('+').last
    elsif params[:variant].present?
      request.variant = params[:variant].to_sym
    end

    request.variant = variant if variant.present?
  end
end

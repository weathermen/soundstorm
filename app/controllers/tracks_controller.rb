class TracksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show listen]

  def show
    @user = User.find(params[:user_id])
    @track = @user.tracks.find(params[:id])
    @title = "#{@track.name} by #{@user.name}"
  end

  def new
    @track = current_user.tracks.build
  end

  def edit
    @track = current_user.tracks.find(params[:id])
  end

  def create
    @track = current_user.tracks.build(new_track_params)

    respond_to do |format|
      if @track.save
        flash[:notice] = t('.success', name: @track.name)

        format.html { redirect_to @track }
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
    @user = User.find(params[:user_id])
    @track = @user.tracks.find(params[:id])
    @track.listens.create(
      ip_address: request.ip_address,
      user: current_user
    )

    head :ok
  end

  def update
    @track = current_user.tracks.find(params[:id])

    respond_to do |format|
      if @track.update(edit_track_params)
        flash[:notice] = t('.success', name: @track.name)

        format.html { redirect_to @track }
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
    params.require(:track).permit(:name, :audio)
  end

  def edit_track_params
    params.require(:track).permit(:name)
  end
end

# frozen_string_literal: true

class CommentsController < ApplicationController
  include CommentsHelper

  swagger_controller :comments, 'Track Comments'

  before_action :authenticate_user!
  before_action :find_track, except: %i[index]

  swagger_api :index do
    param :path, :user_id, :string, :required, 'User who made the track'
    param :path, :track_id, :string, :required, 'Track to comment on'
  end
  def index
    render json: @comments
  end

  swagger_api :show do
    param :path, :user_id, :string, :required, 'User who made the track'
    param :path, :track_id, :string, :required, 'Track to comment on'
    param :path, :id, :integer, :required, 'Comment ID'
  end
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html { redirect_to view_comment_path(@comment) }
      format.json { render json: @comment }
    end
  end

  def edit
    @comment = @comments.find(params[:id])
    @title = %(Edit comment on "#{@track.name}")
  end

  swagger_api :create do
    param :path, :user_id, :string, :required, 'User who made the track'
    param :path, :track_id, :string, :required, 'Track to comment on'
    param :form, 'comment[content]', :string, :required, 'Comment text'
  end
  def create
    @comment = @comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = t('.success', track: @track.name)

        format.html { redirect_to [@user, @track] }
        format.json { render json: @comment, status: :created }
      else
        errors = @comment.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', track: @track.name, errors: errors)

        format.html { redirect_to [@user, @track] }
        format.json { render json: @comment, status: :unprocessable_entity }
      end
    end
  end

  swagger_api :update do
    param :path, :user_id, :string, :required, 'User who made the track'
    param :path, :track_id, :string, :required, 'Track to comment on'
    param :path, :id, :integer, :required, 'Comment ID'
    param :form, 'comment[content]', :string, :required, 'Comment text'
  end
  def update
    @comment = @comments.find(params[:id])

    respond_to do |format|
      if @comment.update(comment_params)
        flash[:notice] = t('.success', track: @track.name)

        format.html { redirect_to [@user, @track] }
        format.json { render json: @comment }
      else
        errors = @comment.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)

        format.html { render :edit }
        format.json { render json: @comment, status: :unprocessable_entity }
      end
    end
  end

  swagger_api :destroy do
    param :path, :user_id, :string, :required, 'User who made the track'
    param :path, :track_id, :string, :required, 'Track to comment on'
    param :path, :id, :integer, :required, 'Comment ID'
  end
  def destroy
    @comment = @comments.find(params[:id])

    respond_to do |format|
      if @comment.destroy
        flash[:notice] = t('.success', track: @track.name)

        format.html { redirect_back fallback_location: [@track.user, @track] }
        format.json { head :ok }
      else
        errors = @comment.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', track: @track.name, errors: errors)

        format.html { redirect_back fallback_location: [@track.user, @track] }
        format.json { render json: @comment, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_track
    @track = Track.find(params[:track_id])
    @user = @track.user
    @comments = @track.comments
  end
end

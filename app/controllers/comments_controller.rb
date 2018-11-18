class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_track

  def edit
    @comment = @comments.find(params[:id])
    @title = %(Edit comment on "#{@track.name}")
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

  def update
    @comment = @comments.find(params[:id])

    respond_to do |format|
      if @comment.update(comment_params)
        flash[:notice] = t('.success')

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

  def destroy
    @comment = @comments.find(params[:id])

    respond_to do |format|
      if @comment.destroy
        flash[:notice] = t('.success', track: @track.name)

        format.html { redirect_to @track }
        format.json { head :ok }
      else
        errors = @comment.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', track: @track.name, errors: errors)

        format.html { redirect_to @track }
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
    @comments = @track.comments
  end
end

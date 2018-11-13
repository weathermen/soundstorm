class CommentsController < ApplicationController
  before_action :find_commentable

  def show
    @comment = @comments.find(params[:id])
  end

  def create
    @comment = @comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = t('.success')

        format.html { redirect_to @comment }
        format.json { render json: @comment, status: :created }
      else
        errors = @comment.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)

        format.html { render :new }
        format.json { render json: @comment, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment = @comments.find(params[:id])

    respond_to do |format|
      if @comment.update(comment_params)
        flash[:notice] = t('.success')

        format.html { redirect_to @comment }
        format.json { render json: @comment, status: :created }
      else
        errors = @comment.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', errors: errors)

        format.html { render :new }
        format.json { render json: @comment, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    @commentable = Commentable.find(params.to_unsafe_h)
    @comments = @commentable.comments
  end
end

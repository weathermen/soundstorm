class LikesController < ApplicationController
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
end

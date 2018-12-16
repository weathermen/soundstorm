# frozen_string_literal: true

class TranslationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @translations = Translation::Collection.new(I18n.t('.'))
  end

  def update
    @translation = Translation.find_by_slug(params[:id])

    respond_to do |format|
      if @translation.update(edit_params)
        flash[:notice] = t('.success', key: @translation.key)

        format.html { redirect_back fallback_location: translations_path }
        format.json { render json: @translation }
      else
        errors = @translation.errors.full_messages.to_sentence
        flash[:alert] = t('.failure', key: @translation.key, errors: errors)

        format.html { render :index }
        format.json { render json: @translation }
      end
    end
  end

  def edit_params
    params.require(:translation).permit(:value)
  end
end

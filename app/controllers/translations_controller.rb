# frozen_string_literal: true

class TranslationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @translations = Translation::Collection.new(I18n.t('.'))
  end

  def update
    @translation = Translation.find_by_slug(params[:id])
    @translation.update(edit_params)
  end

  def edit_params
    params.require(:translation).permit(:value)
  end
end

# frozen_string_literal: true

class SearchesController < ApplicationController
  def show
    @search = Search.new(
      query: params[:q],
      type: params[:type]
    )
  end
end

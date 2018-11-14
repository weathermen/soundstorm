class SearchesController < ApplicationController
  def show
    @search = Search.new(
      query: params[:q],
      type: params[:type]
    )
  end
end

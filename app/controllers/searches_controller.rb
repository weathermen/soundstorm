# frozen_string_literal: true

class SearchesController < ApplicationController
  swagger_controller :searches, 'Search'

  swagger_api :show do
    param :query, :q, :string, :required, 'Search Query'
    param :query, :type, :string, :optional, 'Type of object to search'
  end
  def show
    @search = Search.new(
      query: params[:q],
      type: params[:type]
    )
  end
end

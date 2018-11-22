class ErrorsController < ApplicationController
  def show
    @id = params[:id]
    @scope = [:errors, @id]
    @title = t(:title, scope: @scope)
    @message = t(:message, scope: @scope)
    @status = @id == :too_many_requests ? 429 : @id

    respond_to do |format|
      format.html { render 'show', status: @status }
      format.all { head @status }
    end
  end
end

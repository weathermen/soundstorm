class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit, if: :user_signed_in?

  def index
    if user_signed_in?
      render 'users/dashboard'
    else
      render :index
    end
  end

  def info_for_paper_trail
    { ip: request.ip }
  end
end

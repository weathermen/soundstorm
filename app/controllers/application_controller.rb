class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit, if: :user_signed_in?

  def index
    if user_signed_in?
      render 'users/dashboard'
    else
      render :index
    end
  end

  protected

  def info_for_paper_trail
    { ip: request.ip }
  end

  def cache_page
    expires_in config.page_cache_ttl, public: true if flash.blank?
  end
end

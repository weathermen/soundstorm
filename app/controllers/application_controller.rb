# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :cache_page, only: :index
  before_action :doorkeeper_authorize!, if: :api?
  before_action :configure_permitted_parameters, if: :devise_controller?

  append_before_action :set_paper_trail_whodunnit, if: :user_signed_in?

  after_action :set_headers

  def index
    if user_signed_in?
      @activities = current_user.activities
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

  private

  def set_headers
    response.headers['X-Flash-Messages'] = flash.to_json
    response.headers['X-Requested-With'] = request.headers['X-Requested-With'] || ''
    response.headers['Vary'] = 'X-Requested-With, X-Flash-Messages'
  end

  def api?
    request.format == :json && !request.xhr?
  end

  def configure_permitted_parameters
    keys = %i[email display_name location avatar]

    %i[sign_up account_update].each do |action|
      devise_parameter_sanitizer.permit(action, keys: keys)
    end
  end

  def user_for_paper_trail
    current_user
  end

  def authorize_admin!
    unless current_user&.admin?
      respond_to do |format|
        flash[:alert] = t(:unauthorized, scope: %i[devise failure])

        format.html { redirect_back fallback_location: root_path }
        format.json { render json: { error: flash[:alert] }, status: :unauthorized }
      end
      nil
    end
  end
end

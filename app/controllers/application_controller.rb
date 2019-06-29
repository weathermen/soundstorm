# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :cache_page, only: :splash
  before_action :doorkeeper_authorize!, if: :api?
  before_action :authorize_admin!, only: %w[index]
  before_action :configure_permitted_parameters, if: :devise_controller?

  append_before_action :set_paper_trail_whodunnit, if: :user_signed_in?

  after_action :set_headers

  helper_method :current_model

  def index
    @query = params[:q] || '*'
    @title = t(:admin, scope: %i[application], models: current_model.name.pluralize)
    @models = if current_model.respond_to? :search
      current_model.search(@query).records
    else
      current_model.all
    end
  end

  def splash
    if user_signed_in?
      @activities = current_user.activities
      render 'users/dashboard'
    else
      render 'splash'
    end
  end

  def health
    @title = 'Health Check'
    head :no_content
  end

  protected

  def info_for_paper_trail
    { ip: request.ip }
  end

  def cache_page
    expires_in config.page_cache_ttl, public: true if flash.blank?
  end

  def current_model
    controller_name.classify.constantize
  end

  private

  def set_headers
    response.headers['X-Flash-Messages'] = flash.to_json
    response.headers['X-Page-Title'] = page_title
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

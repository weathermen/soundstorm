class VersionsController < ApplicationController
  before_action :verify_signature

  def create
    @activity = ActivityPub::Activity.new(**activity_data, host: request.headers['Host'])
    @user = User.find_or_create_by_actor_id(@activity.actor.id)

    UpdateActivityJob.perform_later(@user, @activity)

    head :ok
  end

  private

  def activity_data
    activity_params.to_unsafe_h.deep_symbolize_keys.except(:controller, :action)
  end

  def activity_params
    params.permit! # TODO fix this
  end

  def verify_signature
    @signature = request.headers['Signature']
    @date = Time.httpdate(request.headers['Date'])
    @host = request.headers['Host']
    @verification = ActivityPub::Verification.new(@signature, @date, host: @host)

    unless @verification.valid?
      render json: { error: t('.unauthorized') }, status: :unauthorized
      return
    end
  end
end

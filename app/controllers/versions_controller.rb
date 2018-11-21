class VersionsController < ApplicationController
  before_action :verify_signature

  def create
    @signature = request.headers['Signature']
    @date = request.headers['Date']
    @verification

    unless @signature.verified?
      render json: { error: t('.unauthorized') }, status: :unauthorized
      return
    end

    @activity = ActivityPub::Activity.new(**activity_data)
    @user = User.find_or_create_by_actor_id(params[:actor])

    UpdateActivityJob.perform_later(@user, @activity)

    head :ok
  end

  private

  def activity_data
    activity_params.to_unsafe_h.deep_symbolize_keys
  end

  def activity_params
    params.permit(:@context, :id, :type, :actor, :object)
  end
end

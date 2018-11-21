class VersionsController < ApplicationController
  before_action :verify_signature

  def create
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

  def verify_signature
    @signature = request.headers['Signature']
    @date = Time.httpdate(request.headers['Date'])
    @verification = ActivityPub::Verification.new(@signature, @date)

    unless @verification.valid?
      render json: { error: t('.unauthorized') }, status: :unauthorized
      return
    end
  end
end

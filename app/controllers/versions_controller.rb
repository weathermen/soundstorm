class VersionsController < ApplicationController
  def create
    @activity = ActivityPub::Activity.new(**activity_data)
    @user = User.find_or_create_by_actor_id(params[:actor])

    UpdateActivityJob.perform_later(@user, @activity)

    head :accepted
  end

  private

  def activity_data
    activity_params.to_unsafe_h.deep_symbolize_keys
  end

  def activity_params
    params.permit(:@context, :id, :type, :actor, :object)
  end
end

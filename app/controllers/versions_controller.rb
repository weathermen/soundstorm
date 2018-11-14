class VersionsController < ApplicationController
  def create
    @activity = ActivityPub::Activity.new(**activity_params)
    @user = User.find_or_create_by_actor_id(params[:actor])

    UpdateActivityJob.perform_later(@user, @activity)

    head :ok
  end

  private

  def activity_params
    params.permit(:@context, :id, :type, :object)
  end
end

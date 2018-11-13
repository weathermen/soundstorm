class VersionsController < ApplicationController
  def create
    @activity = ActivityPub::Activity.new(**activity_params)
    @user = User.find_or_create_by_actor_id(params[:actor])

    UpdateActivityJob.perform_later(@user, @activity)

    head :ok
    @version = PaperTrail::Version.from_remote(@activity, @user)
    flash[:alert] = t('.success')

    render json: @version, status: :created
  rescue ActiveRecord::RecordNotSaved
    errors = @version.errors.full_messages.to_sentence
    flash[:alert] = t('.failure', errors: errors)

    render json: @version, status: :unprocessable_entity
  end

  private

  def activity_params
    params.permit(:@context, :id, :type, :object)
  end
end

# frozen_string_literal: true

class VersionsController < ApplicationController
  before_action :verify_signature

  def index
    @user = User.find(params[:user_id])
    @activities = PaperTrail::Version.unpublished.where(whodunnit: @user)
  end

  def create
    @activity = ActivityPub::Activity.new(
      host: request.headers['Host'],
      actor: actor_params.to_unsafe_h.deep_symbolize_keys,
      object: object_params.to_unsafe_h.deep_symbolize_keys,
      **activity_params.to_unsafe_h.deep_symbolize_keys
    )
    @user = User.find_or_create_by_actor_id(@activity.actor_id)

    UpdateActivityJob.perform_later(@user, @activity)

    head :ok
  end

  private

  def activity_params
    params.permit(:@context, :id, :type)
  end

  def actor_params
    params.require(:actor).permit(
      :@context,
      :type,
      :id,
      :preferredUsername,
      :name,
      :summary,
      publicKey: %i[id owner publicKeyPem]
    )
  end

  def param_keys_for(type)
    case type
    when 'Note'
      %i[id content]
    else
      [:id]
    end
  end

  def object_params
    params.require(:object).permit(*param_keys_for(params[:object][:type]))
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

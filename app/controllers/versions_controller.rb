# frozen_string_literal: true

class VersionsController < ApplicationController
  before_action :verify_signature
  skip_before_action :verify_authenticity_token
  skip_before_action :doorkeeper_authorize!

  swagger_controller :versions, 'ActivityPub Implementation'

  before_action :verify_signature, only: :create

  swagger_api :index do
    summary 'View all activities a User has left to transmit'

    param :path, :user_id, :string, :required, 'Username'

    response :ok, 'Shows the activities in JSON'
  end
  def index
    @user = User.find(params[:user_id])
    @activities = PaperTrail::Version.unpublished.where(whodunnit: @user)

    render json: @activities
  end

  swagger_api :create do
    summary 'Add Remote Activity'

    param :header, 'Signature', :string, :required, 'Verification Signature'
    param :header, 'Date', :string, :required, 'Current httpdate'
    param :header, 'Host', :string, :required, 'Valid host pointing back to the server that sent the request'

    param :form, 'actor[@context]', :string, :required
    param :form, 'actor[type]', :string, :required
    param :form, 'actor[id]', :string, :required
    param :form, 'actor[preferredUsername]', :string, :required
    param :form, 'actor[name]', :string, :required
    param :form, 'actor[summary]', :string, :required
    param :form, 'actor[publicKey][id]', :string, :required
    param :form, 'actor[publicKey][owner]', :string, :required
    param :form, 'actor[publicKey][publicKeyPem]', :string, :required

    param :form, 'activity[@context]', :string, :required
    param :form, 'activity[id]', :string, :required
    param :form, 'activity[type]', :string, :required

    param :form, :object, :hash, :required, 'The object to send'

    response :ok, 'when activity has been enqueued for processing'
    response :unauthorized, 'if signature cannot be verified'
  end
  def create
    @activity = ActivityPub::Activity.new(
      host: request.headers['Host'],
      object: object_params.to_unsafe_h.deep_symbolize_keys,
      **activity_params.to_unsafe_h.deep_symbolize_keys
    )
    @user = User.find_or_create_by_actor_id(@activity.actor_id)

    UpdateActivityJob.perform_later(@user, @activity)

    head :ok
  end

  private

  def activity_params
    params.permit(:@context, :id, :type, :actor)
  end

  def param_keys_for(type)
    case type
    when 'Audio'
      [:name, url: %i[type href mediaType]]
    when 'Note'
      [:content]
    else
      []
    end
  end

  def object_params
    type_params = param_keys_for(params[:object][:type])
    params.require(:object).permit(:type, :id, *type_params)
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

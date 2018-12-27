# frozen_string_literal: true

class ActivityUpdate
  attr_reader :user, :activity

  delegate :[], to: :attributes

  def initialize(user:, activity:)
    @user = user
    @activity = activity
  end

  def model
    @model ||= case activity.payload[:type]
               when 'Audio' then Track
               when 'Profile' then User
               when 'Note' then Comment
    end
  end

  def model_id
    File.basename(activity.activity_id, '.json')
  end

  def item
    @item ||= find_updated_record do |record|
      params.each do |param, value|
        record.public_send(:"#{param}=", value)
      end
      record.save!
    end
  end

  def metadata
    {
      ip: user.last_sign_in_ip,
      activity: activity.payload
    }
  end

  def event
    activity.id.downcase
  end

  def valid?
    model_id.present? && item&.persisted?
  end

  def attributes
    {
      remote: true,
      item: item,
      event: event,
      whodunnit: user.to_global_id,
      object: metadata
    }
  end

  private

  def params
    activity.payload.except(:id, :type, :actor, :name)
  end

  def find_updated_record(&block)
    record = if model.is_a? User
      model.find_or_create_by(name: user.name)
    elsif model.new.respond_to?(:slug)
      model.find_or_create_by(slug: model_id, user: user)
    else
      model.find_or_create_by(id: model_id, user: user)
    end

    record.tap(&block)
  end
end

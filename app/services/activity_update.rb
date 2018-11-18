class ActivityUpdate
  attr_reader :user, :activity

  def initialize(user:, activity:)
    @user = user
    @activity = activity
  end

  def model
    @model ||= case activity.type
               when 'Audio' then Track
               when 'Profile' then User
               end
  end

  def model_id
    File.basename(activity.payload[:id], '.json')
  end

  def item
    @item ||= model&.find(model_id)
  end

  def metadata
    {
      ip: activity.ip,
      activity: activity.payload
    }
  end

  def event
    activity.id.downcase
  end

  def valid?
    model_id.present? && item.present?
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
end

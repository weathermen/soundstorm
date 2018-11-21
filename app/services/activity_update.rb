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
               when 'Note' then Comment
               end
  end

  def model_id
    File.basename(activity.activity_id, '.json')
  end

  def item
    @item ||= model&.find_or_create_by(id: model_id, user: user) do |record|
      activity.payload.each do |param, value|
        record[param] = value
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
end

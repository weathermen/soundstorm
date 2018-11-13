class UpdateActivityJob < ApplicationJob
  queue_as :default

  def perform(user, activity)
    model = case activity.type
            when 'Audio'
              Track
            when 'Profile'
              User
            else
              raise "Error '#{activity.type}' not supported."
            end
    item = model.find(activity.model_id)

    PaperTrail::Version.create!(
      remote: true,
      item: item,
      event: activity.type.downcase,
      whodunnit: user.to_global_id,
      object: {
        ip: activity.ip,
        activity: activity.payload
      }
    )
  end
end

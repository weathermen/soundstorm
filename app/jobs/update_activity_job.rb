class UpdateActivityJob < ApplicationJob
  queue_as :default

  def perform(user, activity)
    update = ActivityUpdate.new(user: user, activity: activity)

    PaperTrail::Version.create!(update.attributes) if update.valid?
  end
end

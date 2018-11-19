class UpdateActivityJob < ApplicationJob
  queue_as :federation

  def perform(user, activity)
    update = ActivityUpdate.new(user: user, activity: activity)

    PaperTrail::Version.create!(update.attributes) if update.valid?
  end
end

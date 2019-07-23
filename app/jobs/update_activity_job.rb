# frozen_string_literal: true

# Create a new `PaperTrail::Version` when activity is recieved from the
# outside.
class UpdateActivityJob < ApplicationJob
  queue_as :federation

  def perform(user, activity)
    update = ActivityUpdate.new(user: user, activity: activity)

    PaperTrail::Version.create!(update.attributes) if update.valid?
  end
end

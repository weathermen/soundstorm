module Federatable
  extend ActiveSupport::Concern

  included do
    has_paper_trail meta: { activity: :as_activity }
  end

  def activity_id
    Rails.application.routes.url_helpers.url_for(self)
  end

  def as_activity
    {
      id: activity_id,
      type: self.class.name
    }
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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

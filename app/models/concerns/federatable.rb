module Federatable
  extend ActiveSupport::Concern

  included do
    has_paper_trail meta: { activity: :as_activity }
  end

  def as_activity
    {
      id: activity_id,
      type: self.class.name
    }
  end
end

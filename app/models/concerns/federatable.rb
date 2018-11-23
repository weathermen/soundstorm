module Federatable
  extend ActiveSupport::Concern

  included do
    has_paper_trail meta: { activity: :as_activity }
  end

  def activity_id
    raise NotImplementedError, "#{self.class.name}#activity_id"
  end

  def actor_id
    if self.is_a? User
      actor.id
    else
      user.actor_id
    end
  end

  def as_activity
    {
      id: activity_id,
      type: self.class.name,
      actor: actor_id
    }
  end
end

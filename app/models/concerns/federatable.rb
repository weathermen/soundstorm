# frozen_string_literal: true

module Federatable
  extend ActiveSupport::Concern

  included do
    has_paper_trail meta: { activity: :as_activity }
  end

  def actor_id
    if is_a? User
      actor.id
    else
      user.actor_id
    end
  rescue
    actor.id
  end

  def as_activity
    {
      id: activity_id,
      type: self.class.name,
      actor: actor_id
    }
  end
end

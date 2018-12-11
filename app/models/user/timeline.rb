# frozen_string_literal: true

class User::Timeline
  EVENT_NAME = 'create'

  include Enumerable

  delegate_missing_to :to_a

  def initialize(user)
    @user = user
  end

  def to_a
    results.map do |version|
      next unless version.item.present?

      Activity.new(version)
    end.compact
  end

  private

  def results
    PaperTrail::Version.where(event: EVENT_NAME, whodunnit: user_ids)
  end

  # All GlobalIDs, including this one, for users which should appear in the
  # timeline
  def user_ids
    following_user_ids + [@user.to_global_id.to_s]
  end

  def following_user_ids
    @user.following_users.map(&:to_global_id).map(&:to_s)
  end
end

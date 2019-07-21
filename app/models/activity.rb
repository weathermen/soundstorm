# frozen_string_literal: true

class Activity
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  delegate_missing_to :@version

  def initialize(version)
    @version = version
  end

  def subject
    user.name
  end

  def action
    I18n.t(action, scope: i18n_scope)
  end

  def object_name
    if item.respond_to? :track
      item.track.name
    else
      item.name
    end
  end

  def url
    case item_type
    when 'Track'
      [item.user, item]
    when 'Comment'
      [item.user, item.track, item]
    else
      item
    end
  end

  def object
    I18n.t(:object, name: object_name, scope: [item_type.tableize, event])
  end

  def exist?
    item.present?
  end

  def to_partial_path
    'application/activity'
  end

  private

  def i18n_scope
    [item_type.tableize, event]
  end
end

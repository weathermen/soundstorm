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
    I18n.t(:action, scope: i18n_scope)
  end

  def object_name
    if item.respond_to? :track
      item.track.name
    else
      item.name
    end
  end

  def object
    I18n.t(:object, name: object_name, scope: i18n_scope)
  end

  def exist?
    item.present?
  end

  def to_partial_path
    'application/activity'
  end

  private

  def i18n_scope
    [item_type.tableize, item_type.downcase]
  end
end

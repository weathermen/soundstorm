# frozen_string_literal: true

module UsersHelper
  def current_user_browsing?(user)
    user_signed_in? && user == current_user
  end

  def follow_button(user)
    styles = ['profile__follow-button button button--small']
    label = if current_user&.follows?(user)
      styles << 'profile__follow-button--clicked'
      t('.unfollow')
    else
      t('.follow')
    end
    options = {
      method: current_user&.follows?(user) ? :delete : :post,
      class: styles,
      data: {
        action: 'click->follow#toggle',
        target: 'button'
      }
    }

    button_to label, [@user, :follow], options
  end

  def devise_form_for(model, path, **options)
    options[:class] = 'form'
    url = send("#{path}_path", model)
    form_for(model, as: resource_name, url: url, **options) do |form|
      yield form
    end
  end

  def link_to_activity(activity)
    url = if activity.item.is_a?(Comment)
      view_comment_path(activity.item)
    else
      url_for(activity.url)
    end

    link_to url do
      yield
    end
  end
end

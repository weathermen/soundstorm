# frozen_string_literal: true

module UsersHelper
  def current_user_browsing?(user)
    user_signed_in? && user == current_user
  end

  def follow_button(user)
    styles = ['profile__follow-button']
    label = if current_user&.following?(user)
      styles << 'profile__follow-button--clicked'
      t('.unfollow')
    else
      t('.follow')
    end
    options = {
      method: :delete,
      data: {
        action: 'click->follow#toggle',
        target: 'button',
        class: styles
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
end

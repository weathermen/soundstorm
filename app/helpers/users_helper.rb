module UsersHelper
  def follow_button(user)
    styles = ['profile__follow-button']
    label = if current_user&.following_user?(user)
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
end

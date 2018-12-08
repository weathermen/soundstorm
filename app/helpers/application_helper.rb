# frozen_string_literal: true

module ApplicationHelper
  PAGE_TITLE_SEPARATOR = ' - '

  def title_tag
    content_tag :title, title_text
  end

  def title_text
    return app_title unless page_title?

    [page_title, app_title].join(PAGE_TITLE_SEPARATOR)
  end

  def page_title?
    page_title !~ /translation missing/
  rescue StandardError => error
    Rails.logger.debug(error)
    false
  end

  def page_title
    @title ||= t(:title, scope: [controller_name, action_name])
  end

  def app_title
    t(:title, scope: %i[layouts application])
  end

  def splash_link_to(id, path)
    link_to t(id, scope: %i[layouts application nav]), path, class: 'button'
  end

  def turbolinks_stylesheet_tag(path, **options)
    stylesheet_link_tag path, options.merge(data: { turbolinks_track: 'reload' })
  end

  def turblinks_javascript_tag(path, **options)
    javascript_pack_tag path, options.merge(data: { turbolinks_track: 'reload' })
  end

  def nav_class(path)
    css = ['navigation__link']
    css << 'navigation__link--current' if current_page? path
    css
  end

  def nav_link_to(*args, &block)
    if block_given?
      path, options = *args
      options ||= {}

      link_to path, options.merge(class: nav_class(path)), &block
    else
      label, path, options = *args
      options ||= {}
      text = t(label, scope: %i[layouts application nav])

      link_to text, path, options.merge(class: nav_class(path))
    end
  end
end

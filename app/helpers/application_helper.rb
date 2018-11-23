module ApplicationHelper
  def title_tag
    content_tag :title, title_text
  end

  def title_text
    return app_title unless page_title?

    [page_title, app_title].join(' - ')
  end

  def page_title?
    page_title !~ /translation missing/
  rescue
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
end

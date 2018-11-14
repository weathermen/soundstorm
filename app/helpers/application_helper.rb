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
    t(:title, scope: [controller_name, action_name])
  end

  def app_title
    t(:title, scope: :application)
  end
end

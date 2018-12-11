# frozen_string_literal: true

module SearchesHelper
  def search_field_options(placeholder = 'Search...')
    {
      placeholder: placeholder,
      autocomplete: 'off',
      value: params[:q]
    }
  end

  def search_form(url = nil)
    url ||= url_for

    options = {
      url: url,
      method: :get,
      remote: false,
      data: {
        controller: 'search',
        action: 'submit->search#results',
      }
    }

    form_with options do |form|
      yield form
    end
  end

  def search_result_url(result)
    case result
    when Track
      user_track_path(result.user, result)
    when User
      user_path(result)
    end
  end

  def search_filter_url(type)
    url_for(q: params[:q], utf8: params[:utf8], type: type)
  end

  def search_filter_link(type)
    if params[:type] == type
      content_tag :span, class: 'search-filter search-filter--current' do
        yield
      end
    else
      link_to search_filter_url(type), class: 'search-filter' do
        yield
      end
    end
  end

  def search_result_template(result)
    case result.class
    when Track
      [result.user, result]
    when Comment
      [result.user, result.track, result]
    else
      result
    end
  end
end

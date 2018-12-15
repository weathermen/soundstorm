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
    when Comment
      view_comment_path(result)
    when Track
      user_track_path(result.user, result)
    when User
      user_path(result)
    else
      result
    end
  end

  def search_filter_url(type)
    url_for search_params.merge(type: type)
  end

  def search_params
    params.permit(:q, :utf8).to_unsafe_h.symbolize_keys
  end

  def search_filter_class(type)
    css = %w(search-filter)
    css << 'search-filter--current' if params[:type] == type
    css
  end
end

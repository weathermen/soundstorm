# frozen_string_literal: true

module SearchesHelper
  def search_field_options
    {
      placeholder: 'Search...',
      autocomplete: 'off',
      value: params[:q]
    }
  end

  def search_form
    options = {
      url: search_path,
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
end

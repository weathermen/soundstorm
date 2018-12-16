# frozen_string_literal: true

module TranslationsHelper
  def translation_form_for(translation)
    form_with(
      model: translation,
      url: translation_path(id: translation.slug),
      class: %w(translation form),
      method: :put,
      data: {
        controller: 'translation',
        action: %w(
          ajax:success->translation#saved
          ajax:error->translation#failed
        )
      }
    ) { |form| yield form }
  end
end

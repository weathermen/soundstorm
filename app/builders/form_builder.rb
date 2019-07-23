# frozen_string_literal: true

# Base form builder for the entire application.
class FormBuilder < ActionView::Helpers::FormBuilder
  LARGE_BUTTON_CLASS = %w(button button--large)
  DIRECT_UPLOAD_ACTION = 'direct-upload:progress->upload#progress'

  def submit_button
    submit(
      submit_button_text,
      class: LARGE_BUTTON_CLASS,
      data: { disable_with: submit_button_disabled_text }
    )
  end

  def direct_upload_file_field(name, required: nil, **options)
    file_field(
      name,
      options.merge(
        required: required,
        direct_upload: true,
        data: {
          action: DIRECT_UPLOAD_ACTION
        }
      )
    )
  end

  protected

  def i18n_scope
    [
      object.class.table_name,
      object.new_record? ? :new : :edit
    ]
  end

  private

  def submit_button_text
    I18n.t(:submit, scope: i18n_scope)
  end

  def submit_button_disabled_text
    I18n.t(:submitting, scope: i18n_scope)
  end
end

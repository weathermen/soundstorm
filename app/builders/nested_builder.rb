# frozen_string_literal: true

class NestedBuilder < FormBuilder
  def link_to_remove
    styles = %w(button button--small)
    bindings = { action: 'click->nested#remove' }
    text = I18n.t(:remove, scope: i18n_scope)

    @template.link_to text, '#', class: styles, data: bindings
  end

  def link_to_add(text)
    styles = %w(button button--small)
    bindings = { action: 'click->nested#add' }

    @template.link_to text, '#', class: styles, data: bindings
  end

  def destroy_field
    hidden_field :_destroy, value: 0, data: { destroy_field: true }
  end
end

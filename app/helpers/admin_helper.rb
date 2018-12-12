# frozen_string_literal: true

module AdminHelper
  def admin_colspan
    admin_fields.size + 1
  end

  def admin_attribute_name(column)
    current_model.human_attribute_name(column)
  end

  def admin_fields
    current_model.const_get(:FIELDS)
  end

  def admin_search_field_options
    search_field_options("Search #{controller_name}...")
  end

  def admin_row_id(model)
    "#{controller_name.singularize}-#{model.id}"
  end

  def admin_column_class(field)
    "#{controller_name}__#{field.parameterize}"
  end

  def admin_row_class
    "#{controller_name}__row"
  end

  def admin_controls_class
    ['table__controls', "#{controller_name}__controls"]
  end

  def admin_new_path
    [:new, current_model.new]
  end

  def admin_edit_path(model)
    if model.is_a? Comment
      [:edit, model.user, model.track, model]
    elsif model.is_a? Track
      [:edit, model.user, model.track]
    else
      [:edit, model]
    end
  end

  def admin_dependencies(model)
    case current_model
    when Comment
      [model.user, model.track]
    when Track
      [model.user]
    else
      []
    end
  end

  def admin_render_field(model, field)
    if model.respond_to?("#{field}_id")
      model.public_send(field).title
    else
      model.public_send(field)
    end
  end
end

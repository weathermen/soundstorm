# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def param_key
    self.class.model_name.param_key
  end
end

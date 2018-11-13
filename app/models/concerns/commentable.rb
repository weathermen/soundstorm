module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable
  end

  # Return commentable model for given params.
  #
  # @return [Commentable]
  def self.find(params = {})
    subclasses.find do |model|
      next unless params.key?(model.param_key)

      model.find params[model.param_key]
    end
  end
end

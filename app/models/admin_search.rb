# frozen_string_literal: true

class AdminSearch
  def initialize(query: '*', model:)
    @query = query
    @model = model
  end

  def searchable?
    @model.respond_to? :search
  end

  def results
    return @model.all unless searchable?

    @model.search(@query).records
  end
end

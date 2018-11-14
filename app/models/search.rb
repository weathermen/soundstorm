class Search
  include Enumerable

  attr_reader :query, :filters

  delegate :each, to: :results
  delegate_missing_to :results

  def initialize(query: , **filters)
    @query = query
    @filters = filters
  end

  def types
    results.group_by(&:type)
  end

  def results
    []
  end
end

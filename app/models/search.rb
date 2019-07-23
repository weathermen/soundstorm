# frozen_string_literal: true

class Search
  TYPES = %w(user track comment)

  include Enumerable

  attr_reader :query, :filters

  delegate :records, to: :response
  delegate :count, :each, to: :records
  delegate_missing_to :to_a

  def initialize(query:, **filters)
    @query = query
    @filters = filters.compact
  end

  # Find the amount of items in this query for the given type.
  def count_for(type)
    query_for(type).count || 0
  end

  # Total number of all items in the query, without filters applied.
  def total_count
    Search.new(query: query).count
  end

  def css_class
    'search-results--empty' if empty?
  end

  # Base query used for searching items.
  def as_unfiltered_json
    {
      query: {
        bool: {
          must: [
            {
              query_string: {
                query: query
              }
            }
          ]
        }
      }
    }
  end

  # The full Elasticsearch query sent to the server.
  def as_json
    json = as_unfiltered_json
    json[:query][:bool][:must] << {
      type: {
        value: filters[:type]
      }
    } if filters[:type].present?

    json
  end

  private

  def results
    @results ||= response.records
  end

  def response
    @response ||= Elasticsearch::Model.search(as_json)
  end

  def query_for(type)
    Search.new(query: query, **filters.merge(type: type))
  end
end

# frozen_string_literal: true

class Search
  attr_reader :query, :filters

  def initialize(query:, **filters)
    @query = query
    @filters = filters
  end

  def types
    results.group_by { |result| result['_type'] }.map do |type, results|
      records = results.each do |result|
        record_for(result)
      end

      [type, records]
    end
  end

  def each
    results.each do |result|
      yield record_for(result)
    end
  end

  def count
    response['hits']['total']
  end

  private

  def record_for(result)
    model_class = result['_type'].classify.constantize
    attributes = result['_source']

    model_class.new(attributes)
  end

  def results
    response['hits']['hits']
  end

  def response
    @response ||= Elasticsearch::Model.client.search(
      index: "soundstorm_#{Rails.env}",
      body: {
        query: {
          query_string: {
            query: query
          }
        }
      }
    )
  end
end

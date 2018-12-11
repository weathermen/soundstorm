# frozen_string_literal: true

class Search
  TYPES = %w(user track comment)

  include Enumerable

  attr_reader :query, :filters

  def initialize(query:, **filters)
    @query = query
    @filters = filters.compact
  end

  def types
    results.group_by { |result| result['_type'] }.map do |type, results|
      records = results.each do |result|
        record_for(result)
      end

      [type, records]
    end.to_h
  end

  def count_for(type)
    types[type]&.count || 0
  end

  def each
    results.each do |result|
      yield record_for(result)
    end
  end

  def count
    response['hits']['total']
  end

  def as_json
    json = {
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

    json[:query][:bool][:must] << {
      type: {
        value: filters[:type]
      }
    } if filters[:type].present?

    json
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
      body: as_json
    )
  end
end

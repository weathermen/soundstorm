# frozen_string_literal: true

# Point to Elasticsearch server in Docker network
Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV.fetch('ELASTICSEARCH_URL', 'search:9200')
)

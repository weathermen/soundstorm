# frozen_string_literal: true

# Point to Elasticsearch server in Docker network
Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV.fetch('ELASTICSEARCH_URL', 'http://search:9200')
)

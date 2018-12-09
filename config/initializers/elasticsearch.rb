# frozen_string_literal: true

# Configure Elasticsearch with $ELASTICSEARCH_URL
Elasticsearch::Model.client = Elasticsearch::Client.new(
  log: true,
  url: ENV.fetch('ELASTICSEARCH_URL', 'localhost:9200')
)

# frozen_string_literal: true

# Point to Elasticsearch server in Docker network
Elasticsearch::Model.client = Elasticsearch::Client.new(
  log: !Rails.env.test?,
  url: 'search:9200',
)

# frozen_string_literal: true

require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  namespace :index do
    desc 'Create the Elasticsearch index'
    task create: :environment do
      User.__elasticsearch__.create_index! force: true
    end

    desc 'Delete the Elasticsearch index'
    task drop: :environment do
      User.__elasticsearch__.delete_index! force: true
    end
  end
end

desc 'Create search index'
task elasticsearch: %w(
  environment
  elasticsearch:index:create
  elasticsearch:import:all
)

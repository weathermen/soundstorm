source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
gem 'turbolinks_render'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# Use Pry as a Rails console
gem 'pry-rails'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Use Devise for authentication
gem 'devise'
# Use Haml for views
gem 'hamlit-rails'
gem 'pandoc-ruby'
# Generate friendly slugs
gem 'friendly_id'
# Track changes to models
gem 'paper_trail'
gem 'paper_trail-globalid'
gem 'rails-decorators'
# Use HTTP.rb to communicate over ActivityPub
gem 'http'
# Use Logstash and Kibana for logs
gem 'logstasher'
# Provide OAuth with Doorkeepr
gem 'doorkeeper'
# Protect the application against malicious clients
gem 'rack-attack'
# Followers, likes, and mentions
gem 'socialization'

group :development, :test do
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  # Ruby code style guide
  gem 'rubocop'
  # Lint Haml code
  gem 'haml-lint'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Monitor slow and unnecessary queries
  gem 'query_diet'
  # Monitor security issues
  gem 'brakeman', require: false
  # Annotate models with schema comments
  gem 'annotate'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  # Save HTTP requests and mock them for use in later test runs
  gem 'vcr'
  gem 'webmock'
end

group :production do
  # Use Sidekiq to run background jobs in production
  gem 'sidekiq'
  # Send Sidekiq logs to Logstash
  gem 'sidekiq-logstash'
  # Use Redis to store the Rack::Cache HTTP cache
  gem 'redis-rack-cache'
  # Store uploaded files to AWS S3
  gem 'aws-sdk-s3'
end

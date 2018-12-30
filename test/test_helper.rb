# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require 'activity_pub'
require 'vcr'
require 'simplecov'
require 'simplecov-console'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
  config.ignore_hosts('localhost', '127.0.0.1', 'test.host')
end

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start unless ENV['CI']

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup :index_existing_models

  # Turn on versioning for the duration of the block.
  def with_versioning
    was_enabled = PaperTrail.enabled?
    was_enabled_for_request = PaperTrail.request.enabled?
    PaperTrail.enabled = true
    PaperTrail.request.enabled = true
    yield
  ensure
    PaperTrail.enabled = was_enabled
    PaperTrail.request.enabled = was_enabled_for_request
  end

  def users(id)
    super(id).tap do |user|
      key = Rails.root.join('test', 'fixtures', 'files', "#{id}.pem")
      user.update_column(:key_pem, key.read)
    end
  end

  private

  def index_existing_models
    [User, Track, Comment].each(&:import)
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user, password = 'Password1!')
    post new_user_session_path, params: {
      user: { name: user.name, password: password }
    }

    assert_nil flash[:alert]
    assert_redirected_to root_path
  end
end

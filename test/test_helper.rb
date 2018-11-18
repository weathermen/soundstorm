ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require 'activity_pub'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

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
      user.update!(key_pem: key.read)
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user, password = 'Password1!')
    post new_user_session_path, params: {
      user: { email: user.email, password: password }
    }

    assert_nil flash[:alert]
    assert_redirected_to root_path
  end
end

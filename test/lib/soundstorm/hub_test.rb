# frozen_string_literal: true

require 'test_helper'

module Soundstorm
  class HubTest < ActiveSupport::TestCase
    test 'params' do
      assert_equal Rails.configuration.host, Hub.params[:host]
      assert_equal VERSION, Hub.params[:version]
    end

    test 'ping' do
      VCR.use_cassette(:hub) do
        assert_equal 201, Hub.ping.status.to_i
      end
    end
  end
end

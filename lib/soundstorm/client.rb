# frozen_string_literal: true

module Soundstorm
  class Client
    def initialize(base_url:)
      @base_url = base_url
    end

    def apps
      Resource.new(
        path: 'applications'
      )
    end
  end
end

# frozen_string_literal: true

class Search
  class Result
    def initialize(params = {})
      @type = params['_type']
      @attributes = params['_source']
    end
  end
end

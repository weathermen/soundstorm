module Soundstorm
  class Client
    def apps
      Resource.new(
        path: 'applications'
      )
    end
  end
end

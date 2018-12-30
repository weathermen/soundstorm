# frozen_string_literal: true

@track.as_json.each do |(key, value)|
  json.set! key, value
end

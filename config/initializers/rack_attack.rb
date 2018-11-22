class Rack::Attack
  # Always allow requests from localhost
  safelist('ignore/localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  # Always allow requests from admins
  safelist('ignore/admins') do |req|
    !!req.cookie[:admin]
  end

  # Block non-XHR requests to the /:user/:track/listen endpoint.
  # Prevents gaming the listen count system.
  blocklist('listen') do |req|
    req.post? && req.path =~ /listen/ && !req.xhr?
  end

  # Throttle API requests if they reach over 60 rpm from a single IP
  throttle('api', limit: 300, period: 5.minutes) do |req|
    req.ip if req.format == :json && !req.xhr?
  end

  # Throttle requests to media resources if they reach over 1 request
  # per minute
  throttle('media', limit: 30, period: 30.minutes) do |req|
    req.ip if req.get? && req.path.end_with?('.mp3')
  end

  self.blocklisted_response = lambda do
    ErrorsController.render(:show, error: :forbidden)
  end
  self.throttled_response = lambda do
    ErrorsController.render(:show, error: :too_many_requests)
  end
end

# Log whenever Rack::Attack throttles a request.
ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
  next unless [:throttle, :blacklist].include? req.env['rack.attack.match_type']
  Rails.logger.info("Rate limit hit (#{req.env['rack.attack.match_type']}): #{req.ip} #{req.request_method} #{req.fullpath}")
end

class Rack::Attack
  # Always allow requests from localhost
  # (blocklist & throttles are skipped)
  safelist('ignore/localhost') do |req|
    # Requests are allowed if the return value is truthy
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  throttle('protect/api', limit: 300, period: 5.minutes) do |req|
    req.ip if req.format == :json && !req.xhr?
  end

  throttle('protect/media', limit: 30, period: 30.minutes) do |req|
    req.ip if req.post? && req.path.end_with?('.mp3')
  end

  # Configure throttle response
  self.throttled_response = lambda do |env|
    now        = Time.now.utc
    match_data = env['rack.attack.match_data']
    reset = (now + (match_data[:period] - now.to_i % match_data[:period])).iso8601(6)

    headers = {
      'Content-Type'          => 'application/json',
      'X-RateLimit-Limit'     => match_data[:limit].to_s,
      'X-RateLimit-Remaining' => '0',
      'X-RateLimit-Reset'     => reset,
    }

    [
      429,
      headers,
      [
        { error: I18n.t(:too_many_requests, scope: :errors) }.to_json
      ]
    ]
  end
end

ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
  next unless [:throttle, :blacklist].include? req.env['rack.attack.match_type']
  Rails.logger.info("Rate limit hit (#{req.env['rack.attack.match_type']}): #{req.ip} #{req.request_method} #{req.fullpath}")
end

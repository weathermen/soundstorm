# frozen_string_literal: true

# Requires that all requests refer to this application by the configured
# +$SOUNDSTORM_HOST+.
class EnforceHostMiddleware
  delegate :logger, :configuration, to: Rails
  alias_method :config, :configuration

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    return @app.call(env) if host_matches? request

    logger.warn(
      "Host '#{request.host}' does not match expected domain '#{config.host}'"
    )

    response.set_header('Content-Type', request.content_type)
    response.redirect(request.url)
    response.finish
  end

  private

  def host_matches?(request)
    config.host == request.host
  end
end

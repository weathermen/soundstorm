if defined? Raven
  Raven.configure do |config|
    config.dsn = Rails.application.credentials.sentry_dsn
  end
end

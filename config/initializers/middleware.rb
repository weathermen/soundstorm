# frozen_string_literal: true

Rails.application.configure do
  config.middleware.insert_before 0, EnforceHostMiddleware
end

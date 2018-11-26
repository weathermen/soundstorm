# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: -> { "no-reply@#{Rails.configuration.host}" }
  layout 'mailer'
end

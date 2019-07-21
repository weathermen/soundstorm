# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: -> { "no-reply@#{Soundstorm::HOST}" }
  layout 'mailer'
end

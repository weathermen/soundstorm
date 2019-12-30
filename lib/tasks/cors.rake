# frozen_string_literal: true

desc 'Install CORS headers on the S3 bucket'
task cors: :environment do
  s3 = Aws::S3::Client.new(
    region: Rails.application.credentials.aws[:region]
  )

  s3.put_bucket_cors(
    bucket: Rails.application.credentials.aws[:bucket],
    cors_configuration: {
      cors_rules: [
        {
          allowed_headers: %w(*),
          allowed_methods: %w(GET POST PUT DELETE),
          allowed_origins: ["https://#{Rails.configuration.host}"]
        }
      ]
    }
  )
end

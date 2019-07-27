# frozen_string_literal: true

desc 'Install CORS headers on the S3 bucket'
task cors: :environment do
  s3 = Aws::S3::Client.new(region: Soundstorm::AWS_REGION)
  s3.put_bucket_cors(
    bucket: Soundstorm::AWS_S3_BUCKET,
    cors_configuration: {
      cors_rules: [
        {
          allowed_headers: %w(*),
          allowed_methods: %w(GET POST PUT DELETE),
          allowed_origins: ["https://#{Soundstorm::HOST}"]
        }
      ]
    }
  )
end

# frozen_string_literal: true

require "aws-sdk-core"

Aws.config.update(
  # credentials: Aws::Credentials.new(ENV.fetch("AWS_ACCESS_KEY_ID"), ENV.fetch("AWS_SECRET_ACCESS_KEY")),
  # endpoint: ENV.fetch("AWS_S3_ENDPOINT"),
  # region: ENV.fetch("AWS_S3_REGION")
  endpoint: ENV.fetch("AWS_S3_ENDPOINT", nil),
  ignore_configured_endpoint_urls: ENV.fetch("AWS_S3_IGNORE_CONFIGURED_ENDPOINT", 0).to_i.positive?
)

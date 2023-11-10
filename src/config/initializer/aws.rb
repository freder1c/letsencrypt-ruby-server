# frozen_string_literal: true

require "aws-sdk-core"

Aws.config.update(
  endpoint: ENV.fetch("AWS_S3_ENDPOINT", nil),
  ignore_configured_endpoint_urls: ENV.fetch("AWS_S3_IGNORE_CONFIGURED_ENDPOINT", 1).to_i.positive?
)

# frozen_string_literal: true

require "config/environment"

module Application
  module_function

  def root_path
    Pathname.new("/app")
  end

  def s3_bucket_name
    ENV.fetch("S3_BUCKET_NAME")
  end

  def started_at
    @started_at ||= Time.current
  end
end

Dir["#{Pathname.new("/app").join("app")}/**/*.rb"].each { |file| require file }

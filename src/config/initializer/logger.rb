# frozen_string_literal: true

require "logger"

module Application
  Logger = ENV["LOG_PATH"].nil? ? Logger.new($stdout) : Logger.new(ENV["LOG_PATH"], "weekly")

  Logger.formatter = proc do |severity, datetime, progname, msg|
    if ENV["LOG_FORMAT"] == "json"
      {
        msg: "#{progname}#{msg}",
        severity:,
        process_id: Thread.current[:process_id],
        job_id: Thread.current[:job_id],
        duration: Thread.current[:duration],
        status: Thread.current[:status]
      }.compact.to_json.to_s + "\n"
    else
      "[#{datetime.strftime("%Y-%m-%d %H:%M:%S.%6N")} " \
        "##{Thread.current.object_id}-#{Process.pid}] " \
        "#{Thread.current[:process_id] ? "[P-#{Thread.current[:process_id]}] " : ""}" \
        "#{Thread.current[:job_id] ? "[J-#{Thread.current[:job_id]}] " : ""}" \
        "#{severity}: #{progname}#{msg}\n"
    end
  end

  Logger.level = "info"sssss
end

# frozen_string_literal: true

threads_count = Integer(ENV["THREAD_COUNT"] || 5)
threads threads_count, threads_count

environment "production"
pidfile     "puma.pid"

bind "tcp://0.0.0.0:80"

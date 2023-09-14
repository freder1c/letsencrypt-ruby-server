# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "securerandom"

require "config/initializer/logger"
require "config/initializer/sequel"

Dir["#{Pathname.new("/app").join("lib")}/**/*.rb"].each { |file| require file }

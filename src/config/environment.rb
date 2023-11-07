# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "securerandom"
require "openssl"
require "acme-client"

require "config/initializer/logger"
require "config/initializer/sequel"
require "config/initializer/aws"

Dir["#{Pathname.new("/app").join("lib")}/**/*.rb"].each { |file| require file }

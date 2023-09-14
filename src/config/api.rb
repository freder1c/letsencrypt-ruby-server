# frozen_string_literal: true

Dir["#{Pathname.new("/app").join("api")}/**/*.rb"].sort.each { |file| require file }

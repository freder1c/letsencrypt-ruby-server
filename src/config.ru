# frozen_string_literal: true

system("rake db:schema:update")

$LOAD_PATH.unshift(".")

require "config/environment"
require "config/application"
require "config/api"
require "rack/cors"

use Rack::Cors do
  allow do
    origins ENV.fetch("CORS_HOST")
    resource "*", headers: :any, methods: %i[get post delete put patch options head]
  end
end

use Application::Middleware
run Application::Router.freeze.app

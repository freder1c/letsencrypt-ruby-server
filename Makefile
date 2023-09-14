APP       = letsencrypt-ruby-server
BUILD     = latest
APP_IMAGE = $(APP):$(BUILD)

export APP_IMAGE
export BUILD

build:
	docker build -t $(APP_IMAGE) .

dev:
	docker-compose run --service-ports --rm application "bash"

run:
	docker-compose run --service-ports --rm application

schemaupdate:
	docker-compose run application rake db:schema:load

rubocop:
	docker-compose run application rubocop

rspec:
	docker-compose run application rspec

test:
	make rubocop schemaupdate rspec

clean:
	docker-compose down --remove-orphans

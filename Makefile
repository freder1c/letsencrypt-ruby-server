APP       = letsencrypt-ruby-server
BUILD     = latest
APP_IMAGE = $(APP):$(BUILD)

export APP_IMAGE
export BUILD

build:
	docker build -t $(APP_IMAGE) .

dev: build
	docker-compose run --service-ports --rm application "bash"

run: build
	docker-compose run --service-ports --rm application

rspec: build
	docker-compose run --service-ports --rm application "rspec"

rubocop: build
	docker-compose run --service-ports --rm application "rubocop"

test:
	make -k rubocop rspec

clean:
	docker-compose down --remove-orphans

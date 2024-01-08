FROM ruby:3.3.0-alpine3.19

RUN set -ex && apk add bash ruby-dev build-base postgresql-dev postgresql-client

RUN mkdir -p /app
WORKDIR /app
COPY src /app

RUN bundle

CMD ["puma", "-C", "config/puma.rb"]

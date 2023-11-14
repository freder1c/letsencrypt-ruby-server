[![Build and test](https://github.com/freder1c/letsencrypt-ruby-server/actions/workflows/build_and_test.yml/badge.svg?branch=main)](https://github.com/freder1c/letsencrypt-ruby-server/actions/workflows/build_and_test.yml)

# Letsencrypt ruby server

A simple ruby server, wrapping simple api endpoints around acme client to sign certificates via
[letsencrypt.org](https://letsencrypt.org).

### Motivation

I looked recently on my github profile and realised i have a lot of outdated projects. I wanted to have an recent example,
on how a real world example for an api based web application can look like. In plain ruby and without rails framework. I
thought it is a fun project to write an api wrapper around the [acme client](https://github.com/unixcharles/acme-client)
and add some additional enhancements.

A front end application is also in the making, to show a complete web app example. More to that soon.

### Caution

As this application deals stores private keys, please make sure you run this service in a safe environment, and nobody
has access to your private keys!

## Installation

The easiest way to run this server is via docker. There is a convinient Makefile attached to the project, so you just
need to run:

```bash
make run
```

This will run a docker-compose command to spin up a database, localstack environment for storing files on s3 and finally
running the ruby http server app. If you plan to run this app somewhere else, feel free to have a look into the
[docker-compose.yml](https://github.com/freder1c/letsencrypt-ruby-server/blob/main/docker-compose.yml) file, to get an idea
of what configuration is needed.

## Development

To run a development environment with all dependency booted, you can run:

```bash
make dev
```

and to execute only tests, run:

```bash
make test
```

Test will be run on each PR with
[a github action](https://github.com/freder1c/letsencrypt-ruby-server/blob/main/.github/workflows/build_and_test.yml).


## Planned steps

There are a few things still missing. I still plan to add:

- Emails support to send emails for email verification and password reset
- Forgot password functionality
- Websockets, so status of challenge and order can be polled in background and pushed to browser

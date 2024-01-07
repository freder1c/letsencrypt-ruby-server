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

## Usage

### Installation

The easiest way to run this server is via docker. There is a convinient Makefile attached to the project, so you just
need to run:

```bash
make run
```

This will run a docker-compose command to spin up a database, localstack environment for storing files on s3 and finally
running the ruby http server app. If you plan to run this app somewhere else, feel free to have a look into the
[docker-compose.yml](https://github.com/freder1c/letsencrypt-ruby-server/blob/main/docker-compose.yml) file, to get an idea
of what configuration is needed.

### Workflow

_Note: There are some environment variables necessary, to make the setup easier to configure for different stages.
For development purpose, service will connect per default to the staging environment
("https://acme-staging-v02.api.letsencrypt.org/directory") of letsencrypt serivce. If you want the server to run against
production ("https://acme-staging-v02.api.letsencrypt.org/directory") you need to update environment variables. Necassary
env variables you can find in
[docker-compose.yml](https://github.com/freder1c/letsencrypt-ruby-server/blob/main/docker-compose.yml#L13-L25) file._

#### Account setup

First you need to create an account. All keys and orders will be assigned to that account.

```bash
curl http://localhost:3000/account \
-X POST \
-d '{ "email": "john@example.de", "password": "Super-Secret-1!" }'
```

After account is created, you can log in and create a new session:

```bash
curl http://localhost:3000/session \
-X POST \
-d '{ "email": "john@example.de", "password": "Super-Secret-1!" }'

#=> {"token":"1437a6af-3bc7-445c-8f4e-25b654074996"}
```

This will return a token which needs to be used for all following requests. Before orders can be created, a key needs to be
attached to the account. This key will be used to register an account on letsencrypt service. To upload an existing key:

```bash
curl http://localhost:3000/keys/upload \
-X POST \
-H "Authentication: 1437a6af-3bc7-445c-8f4e-25b654074996" \
-F file=@path/to/key.pem

# => {"id":"908398d5c3cd0b2e84d756","created_at":"2024-01-07T17:25:19Z"}
```

or generate a new one:

```bash
curl http://localhost:3000/keys/generate \
-X POST \
-H "Authentication: 1437a6af-3bc7-445c-8f4e-25b654074996"

# => {"id":"908398d5c3cd0b2e84d756","created_at":"2024-01-07T17:25:19Z"}
```

The returned id can be attached to the account. The key_id can be replaced at any time with the same request.

```bash
curl http://localhost:3000/account/key \
-X PUT \
-H "Authentication: 1437a6af-3bc7-445c-8f4e-25b654074996" \
-d '{ "key_id": "908398d5c3cd0b2e84d756" }'
```

#### Create an order

Before creating an order, we need another key. The key attached to account can't be used for an order. They key of an order,
will be the private key for the signed certificate. Again, you can either upload or generate a key.

To create an order:

```bash
curl http://localhost:3000/orders \
-X POST \
-H "Authentication: 1437a6af-3bc7-445c-8f4e-25b654074996" \
-d '{ "key_id": "11c05d1d9e00dc16106244", "identifier": "mydomain.com" }'

#=> {"id":"50f38935-5de6-4a63-bf37-d36ce6a8d786", ...
```

With the order there will be one or more challanges available. Those can be requested with:

```bash
curl http://localhost:3000/orders/50f38935-5de6-4a63-bf37-d36ce6a8d786/challenges \
-X GET \
-H "Authentication: 1437a6af-3bc7-445c-8f4e-25b654074996"
```

The challenge will contain the data needed to fullfil the challenge.

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

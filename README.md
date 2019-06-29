# Soundstorm

[![Build Status](https://travis-ci.org/weathermen/soundstorm.svg?branch=master)](https://travis-ci.org/weathermen/soundstorm)
[![Test Coverage](https://api.codeclimate.com/v1/badges/bc1fd5c8bb8b54b1da49/test_coverage)](https://codeclimate.com/github/weathermen/soundstorm/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/bc1fd5c8bb8b54b1da49/maintainability)](https://codeclimate.com/github/weathermen/soundstorm/maintainability)

The Federated Social Music Platform.

**Soundstorm** is an audio-oriented federated social network that speaks
[ActivityPub][]. Users can upload their own music, comment on others'
tracks, and like/follow/mention just as in a regular social network.
Since it speaks the same language as federated platforms like
[Mastodon][], Soundstorm can send new track upload posts to users'
followers on the fediverse, allowing them to gain a greater reach than a
conventional social audio service.

## Installation

Soundstorm is distributed as a [Docker image][] for deployment ease. The
reference instance, https://soundstorm.social, uses Amazon ECS for
deployment, but the image is self-contained and can be run on any
infrastructure. This image runs in `RAILS_ENV=production` mode by
default.

First, pull down the latest version:

```bash
docker pull weathermen/soundstorm:latest
```

Create a `.env` file in the local dir for your configuration:

```bash
SOUNDSTORM_HOST=your.soundstorm.domain
SOUNDSTORM_ADMIN_USERNAME=your-username
SOUNDSTORM_ADMIN_PASSWORD=your-password
SOUNDSTORM_ADMIN_EMAIL=valid@email.address
DATABASE_URL=postgres://url@to.your.database.server:5432
REDIS_URL=rediss://url@to.your.redis.server:6379
CDN_URL=https://cdn.soundstorm.domain
SMTP_USERNAME=your-smtp-server-user
SMTP_PASSWORD=your-smtp-server-password
SMTP_HOST=smtp.server.if.not.using.sendgrid.net
```

Create the database, set up its schema, and load in seed data:

```bash
docker run --env-file .env weathermen/soundstorm rails db:setup
```

Start the server:

```bash
docker create --env-file .env --publish 3000:3000 weathermen/soundstorm
```

You should now be able to access the app at <http://localhost:3000>.
It's recommended that you proxy dynamic requests from an httpd running
on `:80` and/or `:443`, but this is optional to keep static asset
requests from hitting the app server.

## Development

The above goes into installing Soundstorm for real-world use, but you
may also want to contribute to the project in some way. Developing on
Soundstorm also requires the use of Docker.

First, make sure your `$COMPOSE_FILE` is set, so that development-level
configuration is included whenever `docker-compose` is in use:

```bash
export COMPOSE_FILE="docker-compose.yml:docker-compose.development.yml"
```

Next, set up the database:

```bash
docker-compose run --rm web rails db:setup
```

You can now start all servers:

```bash
docker-compose up
```

You should now be able to visit the server and log in with username
**admin** and password **Password1!**. This is configurable by setting
`$SOUNDSTORM_ADMIN_USERNAME` and `$SOUNDSTORM_ADMIN_PASSWORD` as
environment variables when running `bin/setup`.

For more information on making contributions to this project, read the
[contributing guide][].

## Deployment

Soundstorm can be easily deployed to your **Docker Machine** by setting
the `$DOCKER_HOST` to that of your machine's IP and running the
following command:

```bash
docker-machine create soundstorm
eval "$(docker-machine env soundstorm)"
docker-compose -f docker-compose.yml -f docker-compose.production.yml up
```

The production config also works with AWS ECS, which is how
https://soundstorm.com is deployed:

```bash
ecs-cli compose -f docker-compose.yml -f docker-compose.production.yml up
```

(This assumes that ECS CLI is configured properly and your AWS credentials
are included in the shell as `$AWS_ACCESS_KEY_ID` and
`$AWS_SECRET_ACCESS_KEY`)

[ActivityPub]: https://www.w3.org/TR/activitypub/
[Mastodon]: https://joinmastodon.org
[Docker]: https://www.docker.com/
[Docker image]: https://cloud.docker.com/u/weathermen/repository/docker/weathermen/soundstorm
[Caddy]: https://caddyserver.com
[puma-dev]: https://github.com/puma/puma-dev

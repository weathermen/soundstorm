# Soundstorm

[![Tests Status](https://github.com/weathermen/soundstorm/workflows/Tests/badge.svg)][ci]
[![Build Status](https://github.com/weathermen/soundstorm/workflows/Build/badge.svg)][ci]
[![Release Status](https://github.com/weathermen/soundstorm/workflows/Release/badge.svg)][ci]
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
default, and comes pre-loaded with compiled assets and everything you'll
need to run a Soundstorm instance in production.

First, pull down the latest production image:

```bash
docker pull weathermen/soundstorm
```

Create a `.env` file in the local dir for your configuration:

```bash
SOUNDSTORM_HOST=your.soundstorm.domain
DATABASE_URL=postgres://url@to.your.database.server:5432
REDIS_URL=rediss://url@to.your.redis.server:6379
CDN_URL=https://cdn.soundstorm.domain
SMTP_USERNAME=your-smtp-server-user
SMTP_PASSWORD=your-smtp-server-password
SMTP_HOST=smtp.server.if.not.using.sendgrid.net
RAILS_SERVE_STATIC_FILES=true
```

Create the database, set up its schema, and load in seed data:

```bash
docker run --rm -it \
           --env-file .env \
           --env SOUNDSTORM_ADMIN_USERNAME=your-username \
           --env SOUNDSTORM_ADMIN_PASSWORD=your-password \
           --env SOUNDSTORM_ADMIN_EMAIL=valid@email.address \
           weathermen/soundstorm \
           rails db:setup
```

You can now start the app server using the default container command.
Make sure you have a Docker Network created so the container can talk to
other neighboring containers:

```bash
docker network create soundstorm
docker create --env-file .env --network soundstorm weathermen/soundstorm
```

You'll still need to proxy requests from an HTTP server to the app
server in order to process and terminate SSL. The soundstorm image does
not come with SSL certificates built in, you'll need to either obtain
one yourself or use the [Caddy][] server to obtain them for you via
LetsEncrypt.

Here's an example Caddyfile you can use:

```caddy
your.soundstorm.host {
  log stdout
  errors stderr
  tls {
    dns route53
  }
  root /srv/public


  proxy / http://web:3000 {
    fail_timeout 300s
    transparent
    websocket
    header_upstream X-Forwarded-Ssl on
  }
}
```

Start the Caddy server like this:

```bash
docker pull abiosoft/caddy
docker create \
  --volume $(pwd)/Caddyfile:/etc/Caddyfile \
  --volume $HOME/.caddy:/root/.caddy \
  --publish 80:80 \
  --publish 443:443 \
  --network soundstorm
  abisoft/caddy
```

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

You can now start all services:

```bash
docker-compose up
```

Once the web app loads, browse to <http://localhost:3000> and log in with
username **admin** and password **Password1!**. This is configurable by
setting `$SOUNDSTORM_ADMIN_USERNAME` and `$SOUNDSTORM_ADMIN_PASSWORD` as
environment variables when running `db:setup`.

For more information on making contributions to this project, read the
[contributing guide][].

## Deployment

Soundstorm can be easily deployed to your **Docker Machine** with the
provided production configuration:

```bash
source .env # see "Installation" above
docker-machine create soundstorm
eval "$(docker-machine env soundstorm)"
docker-compose -f docker-compose.yml -f docker-compose.production.yml up
```

However, https://soundstorm.social, our reference implementation, is
hosted on [Heroku][]. The `make deploy` task performs the commands
needed to deploy the local production images you've already built to the
Heroku platform. It uses the `docker` CLI to push images to Heroku's container
registry, and the `heroku` CLI to start those new containers in the
production environment.

[ActivityPub]: https://www.w3.org/TR/activitypub/
[Mastodon]: https://joinmastodon.org
[Docker]: https://www.docker.com/
[Docker image]: https://cloud.docker.com/u/weathermen/repository/docker/weathermen/soundstorm
[Caddy]: https://caddyserver.com
[puma-dev]: https://github.com/puma/puma-dev
[ci]: https://github.com/weathermen/soundstorm/actions

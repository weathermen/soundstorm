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
docker pull tubbo/soundstorm:latest
```

Create a `.env` file for your configuration:

```bash
SOUNDSTORM_HOST=soundstorm.domain
SOUNDSTORM_ADMIN_USERNAME=your-username
SOUNDSTORM_ADMIN_PASSWORD=your-password
SOUNDSTORM_ADMIN_EMAIL=valid@email.address
DATABASE_URL=postgres://url@to.your.database:5432
REDIS_URL=rediss://url@to.your.redis:6379
CDN_URL=https://cdn.soundstorm.domain
SMTP_USERNAME=your-smtp-server-user
SMTP_PASSWORD=your-smtp-server-password
SMTP_HOST=smtp.server.if.not.using.sendgrid.net
RAILS_MAX_THREADS=20
```

Then, run the setup task:

```bash
docker run --rm --env-file .env tubbo/soundstorm rails db:setup
```

This will create the database so you can start the server. Run the app
server and worker containers like so:

```bash
docker run -d -p 3000:3000 --env-file .env tubbo/soundstorm rails server
docker run -d --env-file .env tubbo/soundstorm sidekiq -C config/sidekiq.yml
```

This launches the server at `:3000`, but it requires SSL. If you have
[Caddy][], you can set that up right now with the following `Caddyfile`:

```caddy
https://soundstorm.domain {
  tls your@valid.email.address

  proxy / http://127.0.0.1:3000 {
    fail_timeout 300s
    transparent
    websocket
    header_upstream X-Forwarded-Ssl on
  }
}
```

You can now pull down a Caddy image from Docker and start the HTTP
server, proxying to your local app server...and with that, Soundstorm is
ready to go!

```bash
docker run -d \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/Caddyfile:/etc/Caddyfile
  abiosoft/caddy
```

## Development

The above goes into installing Soundstorm for real-world use, but you
may also want to contribute to the project in some way. For this, it's
recommended that you install dependencies locally.

If you're on a Mac, run this command to install hard dependencies:

```bash
brew bundle
```

On Linux, make sure you have the following packages installed:

- libsndfile-dev
- ffmpeg
- nodejs
- yarn

Next, you can run the setup script to install all application
dependencies onto your machine:

```bash
bin/setup
```

If you're using [puma-dev][], the next step would be to link to
https://soundstorm.test:

```bash
puma-dev link
```

You should now be able to visit the server and log in with username
**admin** and password **Password1!**. This is configurable by setting
`$SOUNDSTORM_ADMIN_USERNAME` and `$SOUNDSTORM_ADMIN_PASSWORD` as
environment variables when running `bin/setup`.

For more information on making contributions to this project, read the
[contributing guide][].

[ActivityPub]: https://www.w3.org/TR/activitypub/
[Mastodon]: https://joinmastodon.org
[Docker]: https://www.docker.com/
[Docker image]: https://cloud.docker.com/u/weathermen/repository/docker/weathermen/soundstorm
[Caddy]: https://caddyserver.com
[puma-dev]: https://github.com/puma/puma-dev

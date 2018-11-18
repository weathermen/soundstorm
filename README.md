# Soundstorm

The Federated Music Platform.

## Features

* Upload music
* Follow users
* Comment on tracks
* Transmit data through [ActivityPub][]

## Installation

Make sure you have [Docker][] installed and run the following command to
set up the database:

```bash
$ docker-compose run web bin/setup
```

## Usage

Start the application by launching all containers:

```bash
$ docker-compose up -d
```

Then, browse to <http://localhost:3000> and log in with
`$SOUNDSTORM_ADMIN_USERNAME` and `$SOUNDSTORM_ADMIN_PASSWORD`, which
defaults to **admin** and **Password1!**.

View logs at any time by running:

```bash
$ docker-compose logs -f [web|db|redis|sidekiq]
```

You can always turn the server off by running:

```bash
$ docker-compose down
```

## Deploying

To build the application for use in production:

```bash
$ docker-compose build web \
  --build-arg RAILS_ENV=production \
  --build-arg RAILS_MASTER_KEY=YOUR_MASTER_KEY
```

Then, push the image to your registry:

```bash
$ docker-compose push web
```

You can now pull the image down with your deployment tool of choice and
start the container.

## Development

To run tests:

```bash
docker-compose run web bin/rails test
```

To run ESLint, StyleLint, and RuboCop lint checks:

```bash
docker-compose run web bin/rails lint
```

[ActivityPub]: https://www.w3.org/TR/activitypub/
[Docker]: https://www.docker.com/

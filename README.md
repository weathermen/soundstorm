# Soundstorm

The Federated Music Platform.

## Features

* Upload music
* Follow users
* Comment on tracks
* Transmit data through [ActivityPub][]

## Installation

Make sure you have [Docker][] installed and run the following command to
set up the database and build initial containers:

```bash
$ ./bin/soundstorm init
```

You'll notice that most directives occur using the `soundstorm` command.
This is a shell script that lives in the `bin/` directory of this repo,
and makes it easier to interface with Docker as well as AWS ECS CLI.

## Usage

Start the application by launching all containers:

```bash
$ ./bin/soundstorm start
```

If you're running [puma-dev][], the application will be available at
<https://soundstorm.test>. Otherwise, browse to <http://localhost:3000>

Then, browse to <http://localhost:3000> and log in with
`$SOUNDSTORM_ADMIN_USERNAME` and `$SOUNDSTORM_ADMIN_PASSWORD`, which
defaults to **admin** and **Password1!**.

View logs at any time by running:

```bash
$ ./bin/soundstorm logs
```

You can always stop the application locally by running:

```bash
$ ./bin/soundstorm stop
```

## Deploying

The easiest way to deploy Soundstorm to production is by using a single
[Docker Machine][] VM. In this example, you'll be creating a Docker
Machine VM on AWS using their built-in driver, but you can use any
driver supported by Docker Machine if you wish.

```bash
$ docker-machine create soundstorm \
  --driver aws \
  --aws-access-key-id="YOUR AWS ACCESS KEY"
  --aws-secret-access-key="YOUR AWS SECRET KEY"
```

Make sure the new `soundstorm` machine is running:

```bash
$ docker-machine ls
```

Then, run the following commands to build the application onto the VM
and set up the database:

```bash
$ eval "$(docker-machine env soundstorm)"
$ docker-compose up -d \
    -f docker-compose.yml
    -f docker-compose.production.yml
$ docker-compose run web bin/rails db:update \
  SOUNDSTORM_ADMIN_USERNAME="your-username" \
  SOUNDSTORM_ADMIN_PASSWORD="your-password" \
  SOUNDSTORM_ADMIN_EMAIL="a-valid@email.address" \
  SOUNDSTORM_HOST="some.host"
```

Once this is all completed, route your new VM with DNS to the domain
specified in `$SOUNDSTORM_HOST`. You'll now be able to view your
production instance and log in with the `$SOUNDSTORM_ADMIN_USERNAME` and
`$SOUNDSTORM_ADMIN_PASSWORD` specified in config.

## Development

To run tests:

```bash
$ ./bin/soundstorm test [FILES] [OPTIONS]
```

To run ESLint, StyleLint, and RuboCop lint checks:

```bash
$ ./bin/soundstorm lint
```

[ActivityPub]: https://www.w3.org/TR/activitypub/
[Docker]: https://www.docker.com/

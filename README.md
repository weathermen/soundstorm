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
and makes it easier to interface with [Docker Compose][] as a developer or
administrator of a Soundstorm instance.

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
Machine VM with the built-in **amazonec2** driver, but you can use any
other driver supported by Docker Machine (and installed onto your
computer) if you wish.

First, create an AWS user with programmatic access, and enable their
access to creating EC2 instances. Then, run the following command to
create the new VM that will act as the remote Docker daemon:

```bash
$ docker-machine create soundstorm \
  --driver amazonec2 \
  --amazonec2-access-key "YOUR AWS ACCESS KEY ID" \
  --amazonec2-secret-key "YOUR AWS SECRET ACCESS KEY" \
  --amazonec2-ssh-keypath ~/.ssh/id_rsa \
  --amazonec2-instance-type t3.xlarge
```

Make sure the new `soundstorm` machine is running:

```bash
$ docker-machine ls
```

Then, build the application onto the machine and set up the database.
The first command in the list below will set the `$DOCKER_HOST` variable
to the remote server, enabling all future `docker-compose` commands to
run on the VM you created in the previous step. The rest build the
application's containers onto the VM and set up the remote database.

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
[Docker Compose]: https://docs.docker.com/compose/
[Docker Machine]: https://docs.docker.com/machine/

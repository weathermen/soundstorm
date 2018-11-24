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

Create a [Docker Machine][] for use with Soundstorm. You can use any
driver supported by Docker, but for this example we'll be using Linode:

```bash
$ docker-machine create soundstorm \
  --driver linode \
  --linode-token=$LINODE_API_KEY \
  --linode-root-password=$LINODE_ROOT_PASSWORD
```

Make sure your new machine is running:

```bash
$ docker-machine ls
```

Then, run the following commands to build the application onto the VM:

```bash
$ eval "$(docker-machine env soundstorm)"
$ ./bin/soundstorm deploy
```

This should also run migrations (or create the database) and start the
application. You should be able to route to this server as if it was
just another Rails application server, exposing the port in your `.env`
file.

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

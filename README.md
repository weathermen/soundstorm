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
$ ./bin/sandstorm init
```

You'll notice that most directives occur using the `sandstorm` command.
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

You can always turn the server off by running:

```bash
$ ./bin/sandstorm stop
```

## Deploying

To build the application for use in production:

```bash
$ ./bin/sandstorm deploy
```

You can now pull the image down with your deployment tool of choice and
start the container.

## Development

To run tests:

```bash
$ ./bin/sandstorm test [FILES] [OPTIONS]
```

To run ESLint, StyleLint, and RuboCop lint checks:

```bash
$ ./bin/sandstorm lint
```

[ActivityPub]: https://www.w3.org/TR/activitypub/
[Docker]: https://www.docker.com/

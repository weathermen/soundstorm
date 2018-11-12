# Soundstorm

The Federated Music Platform.

## Features

* Upload music
* Follow users
* Comment on tracks
* Transmit data through [ActivityPub][]

## Installation

Make sure you have [Docker][] installed and run:

```bash
$ docker-compose run web bin/setup
```

This will build all containers, configure the application, and install the database.

## Usage

Soundstorm can be interacted with using the web application or HTTP API.
Here's how you get it started...

### Running Locally

To view the web application, run the following to start services:

```bash
$ docker-compose up
```

Then, browse to <http://localhost:3000> and log in with
`$SOUNDSTORM_ADMIN_USERNAME` and `$SOUNDSTORM_ADMIN_PASSWORD`, which
defaults to **admin** and **Password1!**.

### Deploying

To build the application for use in production:

```bash
$ docker build . \
  --build-arg RAILS_ENV=production RAILS_MASTER_KEY=YOUR_MASTER_KEY
```

Then, push it to your container registry and start it up!

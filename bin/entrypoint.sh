#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Use secrets when available
if [ -d /run/secrets ]; then
  ln -s /run/secrets/master /usr/src/app/config/master.key
  ln -s /run/secrets/credentials /usr/src/app/config/credentials.yml.enc
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Write `config/master.key` file from k8s secrets
[ -f /run/secrets/master_key ] && \
  [ ! -f /usr/src/app/config/master.key ] &&
  cp /run/secrets/master_key /usr/src/app/config/master.key

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

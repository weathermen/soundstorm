#!/bin/bash
#
# ENTRYPOINT script for Docker containers. This script is run prior to
# any command `exec`-ed or `run` in a container, and ensures the
# database schema and all dependencies are up-to-date.

if [ "$RAILS_ENV" == "production" ]; then
  if [ ! -d /srv/public/assets ]; then
    echo "Precompiling assets..."
    ./bin/rails assets:precompile
  fi
else
  echo "Reconciling dependencies..."
  ./bin/bundle --path=/gems --quiet
  ./bin/yarn --module-path=/node_modules --silent
fi

exec "$@"

#!/bin/bash
#
# ENTRYPOINT script for Docker containers. This script is run prior to
# any command `exec`-ed or `run` in a container, and ensures the
# database schema and all dependencies are up-to-date.

if [ "$RAILS_ENV" != "production" ]; then ./bin/build; fi

exec "$@"

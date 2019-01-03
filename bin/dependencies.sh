#!/bin/bash
#
# Only install dependencies in production

if [ "$RAILS_ENV" == "production" ]; then
  ./bin/build
fi

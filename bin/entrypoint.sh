# Install application dependencies before executing container commands
./bin/bundle --path=/gems && ./bin/yarn --module-path=/node_modules && exec "$@"

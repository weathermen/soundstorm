# Install application dependencies before executing container commands
echo "Reconciling dependencies..."
./bin/bundle --path=/gems --quiet
./bin/yarn --module-path=/node_modules --silent
echo "Running command \`$*\`..."
exec "$@"

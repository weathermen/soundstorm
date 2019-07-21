RAILS_ENV?=development
TRAVIS_TEST_RESULT?=0
HEROKU_APP?=soundstorm-social

# Build the Docker image for the current environment.
all: /usr/local/bin/docker-compose
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml build web

# Set up the database in the Docker environment
install: /usr/local/bin/docker-compose
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml run --rm web bin/rails db:setup

# Begin CodeClimate statistics reporting in CI
ci-before: /usr/local/bin/cc-test-reporter
	@cc-test-reporter before-build

# Run all tests
test: /usr/local/bin/docker-compose
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml run --rm web bin/rails test test/**/*_test.rb
check: test

# Report code coverage statistics to CodeClimate
ci-after: /usr/local/bin/cc-test-reporter
	@cc-test-reporter after-build --exit-code ${TRAVIS_TEST_RESULT}

# Run tests on CI
ci: ci-before test ci-after

# Push the latest image to Docker Hub
push: /usr/local/bin/docker
	@docker push weathermen/soundstorm:latest

# Deploy https://soundstorm.social to Heroku
deploy: /usr/local/bin/docker /usr/local/bin/heroku
	@docker build -t registry.heroku.com/${HEROKU_APP}/worker -f Dockerfile.worker .
	@docker tag weathermen/soundstorm:latest registry.heroku.com/${HEROKU_APP}/web
	@docker push registry.heroku.com/${HEROKU_APP}/web
	@docker push registry.heroku.com/${HEROKU_APP}/worker
	@heroku container:release web worker -a ${HEROKU_APP}
	@heroku run rails db:migrate -a ${HEROKU_APP}

# Release a tagged version to Docker Hub
dist: /usr/local/bin/docker
	@docker tag weathermen/soundstorm:latest weathermen/soundstorm:${TRAVIS_TAG}
	@docker push weathermen/soundstorm:${TRAVIS_TAG}

# Remove all containers and data associated with this installation of
# Soundstorm
clean: /usr/local/bin/docker-compose
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml down --remove-orphans --volumes --rmi all

distclean:
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml down --remove-orphans

# Generate CTags for the Soundstorm codebase
tags:
	@ctags -R .

/usr/local/bin/cc-test-reporter:
	@curl -Lo cc-test-reporter https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64
	@chmod +x ./cc-test-reporter
	@sudo mv ./cc-test-reporter /usr/local/bin/cc-test-reporter

# Raise an error when Docker binaries can't be found
/usr/local/bin/docker-compose:
/usr/local/bin/docker:
	@echo "Error: Docker is not installed, and is required to build this project."
	@exit 1

/usr/local/bin/heroku:
	@curl https://cli-assets.heroku.com/install.sh | sh

.PHONY: all database ci-before test check ci-after ci deploy dist clean distclean

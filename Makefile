RAILS_ENV?=development
HEROKU_APP?=soundstorm-social

# Build the Docker image for the current environment.
all:
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml build web

# Set up the database in the Docker environment
install:
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml run --rm web bin/rails db:setup elasticsearch

# Run all tests
test:
	@docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm web bin/rails test test/**/*_test.rb
check: test

bin/cc-test-reporter:
	@curl https://s3.amazonaws.com/codeclimate/test-reporter/test-reporter-latest-linux-amd64 -o bin/cc-test-reporter
	@chmod +x bin/cc-test-reporter

# Run tests in CI with CodeClimate test coverage reporting
ci: bin/cc-test-reporter
	@docker-compose -f docker-compose.yml -f docker-compose.test.yml run --rm web bin/ci.sh

# Deploy https://soundstorm.social to Heroku
deploy: /usr/local/bin/heroku
	@docker build -t registry.heroku.com/${HEROKU_APP}/worker -f Dockerfile.worker .
	@docker tag weathermen/soundstorm:latest registry.heroku.com/${HEROKU_APP}/web
	@docker push registry.heroku.com/${HEROKU_APP}/web
	@docker push registry.heroku.com/${HEROKU_APP}/worker
	@heroku container:release web worker -a ${HEROKU_APP}
	@heroku run rails db:migrate -a ${HEROKU_APP}

# Provision a new app on Heroku
provision: /usr/local/bin/heroku pull
	@docker build -t registry.heroku.com/${HEROKU_APP}/worker -f Dockerfile.worker .
	@docker tag weathermen/soundstorm:latest registry.heroku.com/${HEROKU_APP}/web
	@docker push registry.heroku.com/${HEROKU_APP}/web
	@docker push registry.heroku.com/${HEROKU_APP}/worker
	@heroku container:release web worker -a ${HEROKU_APP}
	@heroku run rails db:schema:load db:seed elasticsearch cors -a ${HEROKU_APP}

# Release a tagged version to Docker Hub
dist:
	@docker tag weathermen/soundstorm:latest weathermen/soundstorm:${TRAVIS_TAG}
	@docker push weathermen/soundstorm:${TRAVIS_TAG}

# Remove all containers, volumes, and images associated with this
# installation of Soundstorm
clean:
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml down --remove-orphans --volumes --rmi all
	@rm bin/cc-test-reporter

# Remove all containers and volumes associaed with this installation of
# Soundstorm
mostlyclean:
	@docker-compose -f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml down --remove-orphans --volumes

# Remove all production images built by `dist`
distclean:
	@docker image rm weathermen/soundstorm:latest weathermen/soundstorm:$(TRAVIS_TAG)

# Generate CTags for the Soundstorm codebase
tags:
	@ctags -R .

/usr/local/bin/heroku:
	@curl https://cli-assets.heroku.com/install.sh | sh

.PHONY: all database ci-before test check ci-after ci deploy dist clean distclean mostlyclean push pull ci ci-setup ci-report

RAILS_ENV?=development
STACK_OPTS=-c docker-compose.yml -c docker-compose.production.yml -o kubernetes
COMPOSE_OPTS=-f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml
COMPOSE_TEST=-f docker-compose.yml -f docker-compose.test.yml
VERSION?=$(TRAVIS_TAG)

# Build the Docker image for the current environment.
all:
	@docker-compose $(COMPOSE_OPTS) build web
.PHONY: all

# Set up the database in the Docker environment
install:
	@docker-compose $(COMPOSE_OPTS) run --rm web bin/rails install
.PHONY: install

# Run all tests
test:
	@docker-compose $(COMPOSE_TEST) run --rm web bin/rails test test/**/*_test.rb
.PHONY: test
check: test
.PHONY: check

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

# Deploy latest image to https://soundstorm.social. Assumes you have
# `kubectl` installed.
deploy:
	@docker stack $(STACK_OPTS) deploy soundstorm
	@kubectl apply -f config/kubernetes
.PHONY: deploy

# Release a tagged version to Docker Hub
dist:
	@docker tag weathermen/soundstorm:latest weathermen/soundstorm:$(VERSION)
	@docker push weathermen/soundstorm:$(VERSION)
.PHONY: dist

# Remove all containers, volumes, and images associated with this
# installation of Soundstorm
clean:
	@docker-compose $(COMPOSE_OPTS) down --remove-orphans --volumes --rmi all
	@rm -f tags bin/cc-test-reporter bin/compose-api-installer
.PHONY: clean

# Remove all containers and data associated with this installation of
# Soundstorm.
mostlyclean:
	@docker-compose $(COMPOSE_OPTS) down --remove-orphans --volumes
.PHONY: mostlyclean

# Remove all production images built by `dist`
distclean:
	@docker image rm weathermen/soundstorm:latest weathermen/soundstorm:$(TRAVIS_TAG)
.PHONY: distclean

# Generate CTags for the Soundstorm codebase
tags:
	@ctags -R .
.PHONY: tags

# Start services locally for development purposes
start:
	@docker-compose $(COMPOSE_OPTS) up -d --remove-orphans
.PHONY: start

# Stop services when local development is finished
stop:
	@docker-compose $(COMPOSE_OPTS) down --remove-orphans
.PHONY: stop

# Provision your Kubernetes cluster with Helm and the Compose API for
# Kubernetes. This allows deployment using `docker stack`, and assumes
# you have `helm` installed.
compose: bin/compose-api-installer
	@kubectl create namespace compose
	@kubectl -n kube-system create serviceaccount tiller
	@kubectl -n kube-system create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount kube-system:tiller
	@helm init --service-account tiller
	@helm install --name etcd-operator stable/etcd-operator --namespace compose
	@bin/compose-api-installer -namespace=compose -etcd-servers=http://compose-etcd-client:2379
.PHONY: compose

# Pull down the latest Compose API installer.
bin/compose-api-installer:
	@curl https://github.com/docker/compose-on-kubernetes/releases/latest/download/installer-darwin -o bin/compose-api-installer

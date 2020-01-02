RAILS_ENV?=development
STACK_OPTS=-c docker-compose.yml -c docker-compose.production.yml --orchestrator kubernetes
COMPOSE_OPTS=-f docker-compose.yml -f docker-compose.$(RAILS_ENV).yml
COMPOSE_TEST=-f docker-compose.yml -f docker-compose.test.yml
COMPOSE_PROD=-f docker-compose.yml -f docker-compose.production.yml
VERSION?=$(TRAVIS_TAG)
FILES=./Makefile ./docker-compose.*

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
.PHONY: ci

# Deploy latest image to https://soundstorm.social. Assumes you have
# `kubectl` installed.
deploy:
	@docker stack deploy $(STACK_OPTS) soundstorm
	@kubectl apply -f config/kubernetes/prepare.yml
.PHONY: deploy

# Archive necessary files for building Soundstorm for your own needs
dist:
	@git archive --output=dist/installer.tar.gz --prefix=soundstorm-installer/ HEAD $(FILES)

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

# Remove the `dist` folder
distclean:
	@rm -rf $(PKG_DIR)
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
	@helm install etcd-operator stable/etcd-operator --namespace compose
	@kubectl apply -f config/kubernetes/etcd.yml
	@bin/compose-api-installer -namespace=compose -etcd-servers=http://compose-etcd-client:2379
.PHONY: compose

# Pull down the latest Compose API installer.
bin/compose-api-installer:
	@curl -L https://github.com/docker/compose-on-kubernetes/releases/latest/download/installer-darwin -o bin/compose-api-installer
	@chmod +x bin/compose-api-installer

# Install the nginx ingress controller. Assumes you have `helm`
# installed and a cluster configured in `kubectl`.
ingress:
	@helm install nginx-ingress stable/nginx-ingress --set controller.publishService.enabled=true
	@kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
	@kubectl create namespace cert-manager
	@helm repo add jetstack https://charts.jetstack.io
	@helm install cert-manager jetstack/cert-manager --version v0.11.0 --namespace cert-manager
	@docker-compose $(COMPOSE_PROD) run --rm web rails k8s:issuer | kubectl apply -f -
	@docker-compose $(COMPOSE_PROD) run --rm web rails k8s:ingress | kubectl apply -f -
.PHONY: ingress

# Provision the Kubernetes cluster for first-time deployment
cluster: compose ingress
.PHONY: cluster

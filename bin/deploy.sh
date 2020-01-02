#!/usr/bin/env bash
#
# Deploy to Kubernetes while notifying the GitHub Deployments API

url="https://api.github.com/repos/$REPO_NAME/deployments"
headers="Content-Type: application/json"
payload="{ \"ref\": \"$GITHUB_REF\" }"

export DOCKER_STACK_ORCHESTRATOR=kubernetes

curl -X POST "$url" -H "$headers" -d "$payload"

success=$(docker stack deploy -c docker-compose.yml -c docker-compose.production.yml soundstorm)

if [ $success = 0 ]; then
  kubectl apply -f config/kubernetes/prepare.yml
  curl -X POST "$url" -H "$headers" -d "$payload"
fi

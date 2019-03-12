#!/usr/bin/env sh
# Deploy Docker Image

set -e

# authenticate
echo "${DOCKER_PASSWORD}" \
  | docker login --username "${DOCKER_USERNAME}" --password-stdin

# deploy to docker hub
docker push "${TRAVIS_REPO_SLUG:-ashenm/xworkspace}:${TRAVIS_BRANCH:-latest-alpha}"

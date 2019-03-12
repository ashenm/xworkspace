#!/usr/bin/env sh
# Remove Build Images

# only select latest-alpha
# unless explicitly specified
test "$1" = "-a" \
  -o "$1" = "--all" \
    && TRAVIS_BRANCH="*"

# remove selected images
docker images "${TRAVIS_REPO_SLUG:-ashenm/xworkspace}:${TRAVIS_BRANCH:-latest-alpha}" \
  | awk 'NR>1 { print $3 }' \
  | xargs -r docker rmi

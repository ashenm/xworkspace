#!/usr/bin/env sh
# Remove Build Images

docker images "${TRAVIS_REPO_SLUG:-ashenm/xworkspace:dev}" \
  | awk 'NR>1 { print $3 }' \
  | xargs -r docker rmi

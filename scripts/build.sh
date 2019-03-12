#!/usr/bin/env sh
# Build Docker Image

set -e

# clinch permissions
find xworkspace -type d -exec chmod 755 {} \;
find xworkspace -type f -exec chmod 644 {} \;
find xworkspace/usr/local/sbin -type f -exec chmod 755 {} \;
find xworkspace/etc/vnc/xstartup* -type f -exec chmod 755 {} \;

# build :latest
docker build --tag "${TRAVIS_REPO_SLUG:-ashenm/xworkspace}:${TRAVIS_BRANCH:-latest-alpha}" .

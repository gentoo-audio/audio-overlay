#!/usr/bin/env bash
# Run "repoman full" against the entire overlay
set -ex

# Create volume container named "portage" with today's gentoo tree in it
# Ensure the portage image is up to date
docker pull gentoo/portage
# Clean up in case an old volume container exists
docker rm -f portage || true
# Create the new volume container
docker create --name portage gentoo/portage

# Ensure the stage3 image is up to date
docker pull gentoo/stage3-amd64

# Run the repoman tests in a clean stage3
docker run --rm -ti \
  -e GITHUB_TOKEN \
  -e CIRCLECI \
  -e CIRCLE_PROJECT_USERNAME \
  -e CIRCLE_PROJECT_REPONAME \
  -e CIRCLE_PULL_REQUEST \
  -e CIRCLE_PR_NUMBER \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage \
  gentoo/stage3-amd64 \
  /usr/local/portage/tests/resources/repoman.sh

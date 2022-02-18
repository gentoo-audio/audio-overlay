#!/usr/bin/env bash
# Run repoman in a clean stage3
# Pass package names to only run against these packages, otherwise runs agains the whole overlay
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

SCRIPT_PATH=$(dirname "$0")

# Create volume container named "portage" with today's gentoo tree in it
# Ensure the portage image is up to date
docker pull gentoo/portage
# Clean up in case an old volume container exists
docker rm -f portage || true
# Create the new volume container
docker create --name portage gentoo/portage

# Ensure the stage3 image is up to date
docker pull gentoo/stage3

# Run the repoman tests in a clean stage3
docker run --rm -ti \
  -e GITHUB_TOKEN \
  -e CIRCLECI \
  -e CIRCLE_PROJECT_USERNAME \
  -e CIRCLE_PROJECT_REPONAME \
  -e CIRCLE_PULL_REQUEST \
  -e CIRCLE_PR_NUMBER \
  -e DEBUG \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/var/cache/binpkgs \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage \
  gentoo/stage3 \
  /usr/local/portage/tests/resources/repoman.sh "${@}"

#!/usr/bin/env bash
# Run repoman in a clean amd64 stage3
set -ex

docker run --rm -ti \
  -e TRAVIS_REPO_SLUG \
  -e TRAVIS_PULL_REQUEST \
  -e TRAVIS_BOT_GITHUB_TOKEN \
  -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage gentoo/stage3-amd64:latest \
  /usr/local/portage/tests/resources/repoman.sh

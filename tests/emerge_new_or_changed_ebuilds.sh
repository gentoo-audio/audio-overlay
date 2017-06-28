#!/usr/bin/env bash
# Determine which ebuilds are new or changed and emerge them
set -ex

# Get list of new or changed ebuilds
EBUILDS=($(git diff --name-only --diff-filter=d "${TRAVIS_BRANCH:-master}" | grep '\.ebuild$')) || true

# Emerge the ebuilds
for EBUILD in "${EBUILDS[@]}"
do
  docker run --rm -ti -v "${HOME}"/.portage-pkgdir:/usr/portage/packages -v "${PWD}":/usr/local/portage -w /usr/local/portage gentoo/stage3-amd64:latest /usr/local/portage/tests/emerge_ebuild.sh "${EBUILD}"
done

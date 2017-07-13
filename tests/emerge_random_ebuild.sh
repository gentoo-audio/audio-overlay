#!/usr/bin/env bash
# Emerge a random ebuild out of all the ebuilds in the overlay
# Used to do continuous tests if our ebuilds still work
# As well as making sure Travis's cache of the master branch is filled
set -ex

# Pick a random ebuild
EBUILD=$(find . -regex '.*\.ebuild$' -printf '%P\n' | shuf -n1)

# Emerge the ebuild in a clean stage3
docker run --rm -ti -v "${HOME}"/.portage-pkgdir:/usr/portage/packages -v "${PWD}":/usr/local/portage -w /usr/local/portage gentoo/stage3-amd64:latest /usr/local/portage/tests/emerge_ebuild.sh "${EBUILD}"

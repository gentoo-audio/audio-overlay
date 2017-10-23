#!/usr/bin/env bash
# Emerge a random ebuild out of all the ebuilds in the overlay
# Used to do continuous tests if our ebuilds still work
# As well as making sure Travis's cache of the master branch is filled
set -ex

# Pick a random ebuild
EBUILD=$(find . -regex '.*\.ebuild$' -printf '%P\n' | shuf -n1)

# Create volume container named "portage" with today's gentoo tree in it
# Ensure the portage image is up to date
docker pull gentoo/portage
# Clean up in case an old volume container exists
docker rm -f portage || true
# Create the new volume container
docker create --name portage gentoo/portage

# Ensure the stage3 image is up to date
docker pull gentoo/stage3-amd64

# Emerge the ebuild in a clean stage3
docker run --rm -ti \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage gentoo/stage3-amd64 \
  /usr/local/portage/tests/emerge_ebuild.sh "${EBUILD}"

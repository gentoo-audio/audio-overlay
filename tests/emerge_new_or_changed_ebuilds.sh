#!/usr/bin/env bash
# Determine which ebuilds are new or changed and emerge them
set -ex

# Get list of new or changed ebuilds
EBUILDS=($(git diff --name-only --diff-filter=d "${TRAVIS_BRANCH:-master}" | grep '\.ebuild$')) || true

# Create volume container named "portage" with today's gentoo tree in it
# Ensure the portage image is up to date
docker pull gentoo/portage
# Clean up in case an old volume container exists
docker rm -f portage || true
# Create the new volume container
docker create --name portage gentoo/portage

# Ensure the stage3 image is up to date
docker pull gentoo/stage3-amd64

# Emerge the ebuilds in a clean stage3
for EBUILD in "${EBUILDS[@]}"
do
  docker run --rm -ti \
    --cap-add=SYS_PTRACE \
    --volumes-from portage \
    -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
    -v "${PWD}":/usr/local/portage \
    -w /usr/local/portage gentoo/stage3-amd64 \
    /usr/local/portage/tests/emerge_ebuild.sh "${EBUILD}"
done

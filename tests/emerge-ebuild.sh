#!/usr/bin/env bash
# Emerge a specific ebuild in a clean amd64 stage3
set -ex

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <package category>/<package name>/<package name and version>.ebuild" >&2
  exit 1
fi

# Pick a random ebuild
EBUILD="${1}"

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
  --cap-add=SYS_PTRACE \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage \
  gentoo/stage3-amd64 \
  /usr/local/portage/tests/resources/emerge-ebuild.sh "${EBUILD}"

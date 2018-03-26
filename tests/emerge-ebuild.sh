#!/usr/bin/env bash
# Emerge a specific ebuild in a clean amd64 stage3
set -ex

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <package category>/<package name>/<package name and version>.ebuild" >&2
  exit 1
fi

EBUILD="${1}"

# Ensure the stage3 image is up to date
docker pull gentoo/stage3-amd64

# Emerge the ebuild in a clean stage3
docker run --rm -ti \
  --cap-add=SYS_PTRACE \
  -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
  -v "${PWD}":/usr/local/portage \
  --tmpfs /var/tmp/portage:exec \
  -w /usr/local/portage \
  gentoo/stage3-amd64 \
  /usr/local/portage/tests/resources/emerge-ebuild.sh "${EBUILD}"

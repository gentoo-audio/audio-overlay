#!/usr/bin/env bash
# Emerge a specific ebuild in a clean stage3
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <ebuild category>/<ebuild name>/<ebuild filename>.ebuild [<second ebuild category>/<second ebuild name>/<second ebuild filename>.ebuild]" >&2
  exit 1
fi

# Create volume container named "portage" with today's gentoo tree in it
# Ensure the portage image is up to date
docker pull gentoo/portage
# Clean up in case an old volume container exists
docker rm -f portage || true
# Create the new volume container
docker create --name portage gentoo/portage

# Ensure the stage3 image is up to date
docker pull gentoo/stage3

# Emerge the ebuild in a clean stage3
docker run --rm -ti \
	-e GITHUB_TOKEN \
	-e CIRCLECI \
	-e CIRCLE_PROJECT_USERNAME \
	-e CIRCLE_PROJECT_REPONAME \
	-e CIRCLE_PULL_REQUEST \
	-e CIRCLE_PR_NUMBER \
	-e DEBUG \
  --cap-add=SYS_PTRACE \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/var/cache/binpkgs \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage \
  gentoo/stage3 \
  /usr/local/portage/tests/resources/emerge-ebuild.sh "${@}"

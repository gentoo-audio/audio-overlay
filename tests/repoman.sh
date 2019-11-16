#!/usr/bin/env bash
# Determine which ebuilds are new or changed and run repoman on their packages
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

SCRIPT_PATH=$(dirname "$0")

PACKAGES=""
if [[ -n "${CIRCLE_PULL_REQUEST}" ]]; then
  # Get list of new or changed packages
  IFS=" " read -ra EBUILDS <<< "$("${SCRIPT_PATH}/get-new-or-changed-ebuilds.sh")"
  IFS=" " read -ra PACKAGES <<< "$(for EBUILD in "${EBUILDS[@]}"; do dirname "${EBUILD}"; done | sort -u)"
  echo "Running repoman on the following packages:" "${PACKAGES[@]}"
fi

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
  -e DEBUG \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/var/cache/binpkgs \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage \
  gentoo/stage3-amd64 \
  /usr/local/portage/tests/resources/repoman.sh "${PACKAGES[@]}"

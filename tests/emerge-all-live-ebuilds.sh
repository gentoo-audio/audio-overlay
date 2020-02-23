#!/usr/bin/env bash
# Get all live ebuilds that are in the git tree and emerge all of them in a clean amd64 stage3
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

SCRIPT_PATH=$(dirname "$0")

EBUILDS=($(git ls-files | egrep -e '.+9999(-r[0-9]+)?.ebuild$'))

echo "Emerging the following ebuilds: ${EBUILDS[@]}"

# Emerge the ebuilds in a clean stage3
"${SCRIPT_PATH}/emerge-ebuild.sh" "${EBUILDS[@]}"

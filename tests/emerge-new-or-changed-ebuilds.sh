#!/usr/bin/env bash
# Determine which ebuilds are new or changed and emerge them in a clean amd64 stage3
set -ex

SCRIPT_PATH=$(dirname "$0")

# Get list of new or changed ebuilds
EBUILDS=($(git diff --name-only --diff-filter=d "${TRAVIS_BRANCH:-master}" | grep '\.ebuild$')) || true

# Emerge the ebuilds in a clean stage3
for EBUILD in "${EBUILDS[@]}"
do
  "${SCRIPT_PATH}/emerge-ebuild.sh" "${EBUILD}"
done

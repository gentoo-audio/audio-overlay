#!/usr/bin/env bash
# Determine which ebuilds are new or changed and emerge them in a clean stage3
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

SCRIPT_PATH=$(dirname "$0")

IFS=" " read -ra EBUILDS <<< "$("${SCRIPT_PATH}/get-new-or-changed-ebuilds.sh")"

if [ ${#EBUILDS[@]} -eq 0 ]; then
  echo "No changed ebuilds found, skipping emerge tests"
else
  echo "Emerging the following ebuilds:" "${EBUILDS[@]}"
  "${SCRIPT_PATH}/emerge-ebuild.sh" "${EBUILDS[@]}"
fi

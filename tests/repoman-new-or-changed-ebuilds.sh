#!/usr/bin/env bash
# Determine which ebuilds are new or changed and run repoman on their packages
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

SCRIPT_PATH=$(dirname "$0")

PACKAGES=""
# Get list of new or changed packages
IFS=" " read -ra EBUILDS <<< "$("${SCRIPT_PATH}/get-new-or-changed-ebuilds.sh")"
mapfile -t PACKAGES < <(for EBUILD in "${EBUILDS[@]}"; do dirname "${EBUILD}"; done | sort -u)

if [ ${#PACKAGES[@]} -eq 0 ]; then
  echo "No changed packages found, skipping repoman check"
else
  echo "Running repoman on the following packages:" "${PACKAGES[@]}"
  "${SCRIPT_PATH}/repoman.sh" "${PACKAGES[@]}"
fi

#!/usr/bin/env bash
# Determine which ebuilds are new or changed and emerge them in a clean amd64 stage3
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

SCRIPT_PATH=$(dirname "$0")

IFS=" " read -ra EBUILDS <<< "$("${SCRIPT_PATH}/get-new-or-changed-ebuilds.sh")"

echo "Detected changes to the following ebuilds: ${EBUILDS[@]}"

# Emerge the ebuilds in a clean stage3
for EBUILD in "${EBUILDS[@]}"
do
  echo "Emerging ${EBUILD}"
  "${SCRIPT_PATH}/emerge-ebuild.sh" "${EBUILD}"
done
